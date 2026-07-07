#!/bin/bash
# Tiered safety guard — blocks destructive commands before execution.
# Registered as a pre-execution hook on the agent's shell tool.
#
# Exit codes:
#   0 = allow (optionally with a warning on stderr)
#   2 = hard block (the command never runs)
#
# Design notes:
# - Guards are conservative by default. Relaxing one is a conversation with
#   the human, not a silent edit.
# - Judge the FIRST TOKEN of the command, then narrow — this avoids false
#   positives on heredocs and quoted strings, which would otherwise train
#   everyone to ignore the guard.
# - This file is a sanitized, generalized version of the live hook; the
#   block list below is the transferable core.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

[ -z "$COMMAND" ] && exit 0

BASE_CMD=$(echo "$COMMAND" | sed 's/^[[:space:]]*//' | cut -d' ' -f1)
FIRST_LINE=$(echo "$COMMAND" | head -1)

# ============================================================
# TIER 1: HARD BLOCK (exit 2) — irrecoverable operations
# ============================================================

case "$BASE_CMD" in
  rm)
    case "$FIRST_LINE" in
      rm\ -rf\ /*|rm\ -rf\ \~*|rm\ -rf\ .)
        echo "BLOCKED: rm -rf with dangerous target" >&2
        exit 2
        ;;
    esac
    ;;
  git)
    case "$FIRST_LINE" in
      git\ push\ --force\ *|git\ push\ --force|git\ push\ -f\ *)
        echo "BLOCKED: git push --force (use --force-with-lease, with approval)" >&2
        exit 2
        ;;
      git\ reset\ --hard*)
        echo "BLOCKED: git reset --hard" >&2
        exit 2
        ;;
    esac
    ;;
  sudo)
    echo "BLOCKED: sudo" >&2
    exit 2
    ;;
  curl|wget)
    case "$FIRST_LINE" in
      *\|*bash*|*\|*sh*)
        echo "BLOCKED: piping remote content to a shell" >&2
        exit 2
        ;;
    esac
    ;;
  psql|mysql|sqlite3)
    case "$FIRST_LINE" in
      *DROP\ TABLE*|*DROP\ DATABASE*|*drop\ table*|*drop\ database*)
        echo "BLOCKED: DROP TABLE/DATABASE from an agent shell" >&2
        exit 2
        ;;
    esac
    ;;
esac

# System/tooling directories that must never be touched by rm-like commands
if [ "$BASE_CMD" = "rm" ] || [ "$BASE_CMD" = "trash" ]; then
  case "$COMMAND" in
    *\ /System/*|*\ /Library/*)
      echo "BLOCKED: system directory modification" >&2
      exit 2
      ;;
    *.claude/projects*)
      echo "BLOCKED: agent session history deletion" >&2
      exit 2
      ;;
  esac

  # ==========================================================
  # TIER 2: WARN (exit 0 + stderr) — recoverable, but pause
  # ==========================================================
  case "$COMMAND" in
    *Caches/*)
      echo "WARNING: cache deletion — verify the target is one app's cache, not the whole dir." >&2
      ;;
    *node_modules*)
      echo "WARNING: node_modules deletion — recoverable via install, but confirm intent." >&2
      ;;
    *.venv*|*venv/*)
      echo "WARNING: virtualenv deletion — recoverable via re-sync." >&2
      ;;
    *Downloads/*)
      echo "WARNING: Downloads deletion — verify contents first." >&2
      ;;
  esac
fi

case "$COMMAND" in
  docker\ system\ prune*|docker\ volume\ prune*)
    echo "WARNING: docker prune removes stopped containers and dangling images." >&2
    ;;
esac

exit 0
