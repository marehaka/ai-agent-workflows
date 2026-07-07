# 1 — Context & Memory

**Question: what should the agent read, and how does it remember?**

## The failure this solves

Long-running projects accumulate hundreds of documents. Agents given "the
whole project" read none of it well: they grab stale files, miss the one
decision that matters, and hallucinate the rest. Agents given nothing
re-derive everything, differently each time.

## Pattern 1: a fixed directory taxonomy with different lifecycles

Every project uses the same seven top-level divisions, each with a distinct
read/write contract for agents:

| Division | Contains | Agent contract |
|---|---|---|
| `Foundation/` | Principles and rules (slow-changing) | Read at session start; never edit casually |
| `Project/` | Project-specific docs, guides, research | Read on demand via the router |
| `Management/` | Plans, ADRs, PRDs, handoffs | The planning agent's workspace |
| `Workers/` | Ephemeral agent sandboxes | Isolated; destroyed after close-out |
| `Knowledge/` | Glossaries + the derived-index KB | Query before acting |
| `Records/` | Append-only history (sessions, logs) | Append, never rewrite |
| `Archives/` | Frozen past material | Do not touch |

The point is not the names — it is that **"where a file lives" tells the
agent how to treat it** without per-file instructions.

## Pattern 2: a navigation router instead of a giant instructions file

A single `NAVIGATION.md` holds two tables: *task type → documents to read*
and *rule change → documents to propagate to*. The agent reads the router,
then only what the router names. Project-specific values (names, paths,
issue prefixes) live in one `project.yaml`, so the router itself stays
generic and reusable across projects.

## Pattern 3: markdown is the source of truth; the database is derived

Records accumulate as human-readable markdown logs (decisions, learnings,
questions, best practices / anti-patterns — each with a typed ID). A SQLite
database with FTS5 full-text search is **rebuilt from the markdown** by an
ingest script; agents query it before starting work.

```
markdown logs (SoT, git-tracked)
    └─ ingest.py →  kb.db (derived, gitignored, rebuildable)
                       └─ query.py — full-text + tag search, used by agents
```

Why derived instead of primary: humans keep reviewing and editing what they
can read; the database can always be regenerated; nothing is lost if the
index breaks. See the working schema:
[`examples/knowledge-base/schema.sql`](../examples/knowledge-base/schema.sql).

## What it looked like before

Before the KB: the same mistake recurred across sessions because the learning
that would have prevented it sat unread in a month-old log file. After: the
session-start routine and a pre-work query surface prior decisions and
anti-patterns as a matter of procedure, not luck.
