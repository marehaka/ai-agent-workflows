# 3 — Safety & Governance

**Question: what must the agent never do — and how is that enforced?**

## The failure this solves

Instruction files say "never force-push". Agents follow instructions
*probabilistically*. On a long enough project, "usually obeys" means
"eventually doesn't". Anything irrecoverable needs enforcement that does not
depend on the model's mood.

## Pattern: three tiers, enforced at different strengths

| Tier | Enforcement | Examples |
|---|---|---|
| **Hard block** | Pre-execution hook exits non-zero; the command never runs | `rm -rf` on dangerous targets, `git push --force`, `git reset --hard`, `sudo`, piping remote scripts to shell, `DROP TABLE` |
| **Warn** | Hook lets the command run but injects a caution the agent must weigh | cache / `node_modules` / venv deletion, docker prune |
| **Soft steer** | Hook injects context nudging toward the canonical path, non-blocking | secret access → "use the secrets manager, not the .env file" |

Working example: [`examples/hooks/guard-dangerous.sh`](../examples/hooks/guard-dangerous.sh).
Two design details matter more than the block list:

1. **Judge the first token of the command**, not the whole string — otherwise
   heredocs and quoted strings produce false positives that train everyone to
   ignore the guard.
2. **Deterministic beats instructional.** Rules the agent must *remember* go
   in instructions; rules that must *hold* go in hooks. The dividing line is
   recoverability.

## Pattern: edit-time guards

Two smaller hooks wrap file edits: a pre-edit check that refuses to modify a
file the agent has not read in this session (no blind edits), and a post-edit
reminder that surfaces the project's best-practice checklist for the file
type just touched.

## Pattern: authority delegation

A short rules document defines what the agent may do alone, what needs a
stated plan first, and what always needs explicit human approval (deletion,
force operations, anything customer-facing, anything that changes money).
The agent quotes the relevant tier when asking — governance becomes part of
the conversation, not an afterthought.

## What it looked like before

The guard exists because each blocked pattern burned me at least once in
early months — the force-push that ate a branch, the "cleanup" that deleted
a cache mid-build. The block list is a scar tissue inventory, which is
exactly why it transfers: your agent will attempt the same commands.
