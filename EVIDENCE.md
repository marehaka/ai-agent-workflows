# Evidence map

Every substantive claim this repository (or my profile) makes, mapped to what
you can verify and how. Claims are worthless without this table; AI-assisted
work makes honest evidence *more* important, not less.

Legend — **In repo**: verifiable from files here. **Private evidence**:
exists in private repos / records; verifiable in an interview walkthrough.

| Claim | Evidence in this repo | Private evidence |
|---|---|---|
| A tiered safety guard hard-blocks irrecoverable agent actions | [examples/hooks/guard-dangerous.sh](examples/hooks/guard-dangerous.sh) (working script) | Hook registration + months of blocked-command logs |
| Sessions restore context from durable records, not memory | [examples/skills/session-init/SKILL.md](examples/skills/session-init/SKILL.md) + [docs/02](docs/02-session-lifecycle.md) | 180+ session records across 8 months, 80+ session summaries |
| Agents query a structured knowledge base before acting | [examples/knowledge-base/schema.sql](examples/knowledge-base/schema.sql) + [docs/01](docs/01-context-and-memory.md) | Live SQLite KB: 2,600+ entries (decisions / learnings / anti-patterns), FTS5 search, ingest + query CLI |
| Worker agents hand off via a fixed close-record contract | [examples/delivery/close-record-template.md](examples/delivery/close-record-template.md) + [docs/04](docs/04-multi-agent-delivery.md) | 80+ close-records from 26 worker agents on a production project |
| Decisions are recorded so agents stop re-opening them | [examples/decisions/adr-template.md](examples/decisions/adr-template.md) + [docs/05](docs/05-conventions.md) | 40+ ADRs (bilingual) + 850+ logged decisions in the KB |
| The harness runs a real delivery loop, not a demo | [README.md](README.md) provenance section | Production internal operations platform (e-commerce / artist production): 500+ issues structured into epics/milestones/blocks; PM board with 500+ items I own and operate |
| One person operates orchestrator / worker / maintainer roles | [docs/04-multi-agent-delivery.md](docs/04-multi-agent-delivery.md) | Role charters, handoff documents, escalation records from live operation |

## What is deliberately *not* claimed

- **"Autonomous" or "self-improving" AI** — the knowledge base gives agents
  memory; the improvement loop still runs through human review. Foundations
  exist; the strong version of the claim would be overclaiming.
- **Senior full-stack engineering** — implementation is executed by AI agents
  under my decomposition, review gates, and acceptance criteria. I claim the
  system around the AI, not solo coding depth.
- **That these exact files run my projects** — published examples are
  sanitized and generalized from the live versions (private names, paths, and
  project context removed). Structure and logic are faithful.
