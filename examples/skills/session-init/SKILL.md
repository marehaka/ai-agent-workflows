---
name: session-init
description: >
  Restore project context at the start of a session — from durable records,
  not from the model's memory. Reads the latest session summary and session
  record, scans open issues and unanswered human feedback, and proposes
  today's scope. Use when starting a new session, resuming after compaction,
  or re-orienting mid-project. Skip for mid-session checkpoints (that is the
  extract skill's job).
---

# Skill: session-init

Restore project context at the start of a session — from durable records,
not from the model's memory. The agent ends this skill by proposing today's
scope; the human decides.

*(Sanitized template of the live skill. Adjust paths via your project config.)*

## Objective

- Rebuild context from the latest session summary + session record
- Detect what changed since last time: open issues, new human feedback
- Present a structured report with 2–3 scope candidates for today

## Workflow

### Step 1 — Read the last session summary's metadata

Locate the newest `logs/<YYYY-MM>/Session_Summary_*.md`. Extract:

- the timestamp of the last session-close run (baseline for "what's new")
- the list of session records it consolidated (input for Step 2)

If missing → fall back to the previous month; if none exists, declare a
fresh start explicitly (never silently pretend context exists).

### Step 2 — Read the latest session record in full

Read the newest session record; walk backwards through earlier ones only if
context is still insufficient (judge, don't mechanically read everything).

Read with priority on:

- human decisions, direction changes, explicit instructions
- unfinished threads (`TODO:` inline) and unresolved discussions
- decision / learning / question candidates awaiting promotion

### Step 3 — Scan open issues for changes

List open issues; for any updated after the Step 1 baseline, check for new
human comments. Cross-reference with the issues touched in the last session
record to identify continuation candidates. Skip silently if the issue
tracker is unreachable (note it in the report).

### Step 4 — Scan for unanswered human feedback

Check the places where the human leaves feedback between sessions (inline
markers in the last summary, comments in recent working documents, new issue
comments). Report each source as *found / unprocessed* counts with pointers
— unanswered feedback outranks new work.

### Step 5 — Structured report

```markdown
## Session Context
### 1. Last session summary        (what happened, what completed)
### 2. Issue status                (new comments / high-priority / in-progress)
### 3. Feedback processing status  (per source: found N, unprocessed M, where)
### 4. Cautions                    (fallbacks applied, unanswered feedback)
### 5. Scope proposal              (2–3 candidates; the human decides)
```

## Boundaries

- This skill **reads and reports**; it never creates or edits records
  (that belongs to the extract/close skills)
- It proposes scope; it does not choose it
