# 5 — Conventions

**Question: what makes all of this reproducible?**

## The failure this solves

A harness that lives in one person's habits dies with a context switch. The
patterns in this repo only compound if decisions, formats, and project
wiring are explicit enough that a *new agent instance* — or a second
project — picks them up without oral tradition.

## Pattern: decisions get records, not vibes

Any decision that would be expensive to re-litigate becomes an ADR — status,
context, decision, consequences — numbered and linked from the issues it
affects. Agents are instructed to treat ADRs as settled: challenging one
requires writing a superseding ADR, not quietly diverging. On the production
project this grew to 40+ ADRs; the visible effect is that agents stopped
re-opening the same architecture arguments every few sessions.
Template: [`examples/decisions/adr-template.md`](../examples/decisions/adr-template.md).

## Pattern: generic master + project instance

Skills and routers are written once, generically, and parameterized per
project by a single `project.yaml` (names, paths, commit prefixes, board
IDs). Forked projects inherit improvements by syncing the master; patterns
discovered downstream flow back through an explicit upstream-proposal step.
The test of the pattern: this harness runs several unrelated projects with
the same skill set and different YAML.

## Pattern: even commit messages are structured

Commit messages are generated from a per-project pattern file (type prefixes,
scope vocabulary, language). Trivial in isolation; the point is the
principle applied everywhere: **anything an agent produces repeatedly gets a
format, and formats live in files, not in prompts.**

## The quiet meta-rule

Every convention here earned its place by recurring pain, and each is
documented next to the failure it prevents. Conventions adopted for
tidiness' sake get deleted — maintenance load is the budget, and it is
always smaller than you hope.
