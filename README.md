# Building and Running AI Agent Workflows

English · [日本語](README.ja.md)

I develop and use an environment for working with AI agents across software development and research projects. It combines orchestration with knowledge and context management so agents can work with the information and decisions relevant to their task.

## Agent-First Information Design

The aim is for an agent to retrieve the information it needs when it needs it and assemble an appropriate working context. I structure business knowledge, work records, decisions and their reasoning, open questions, and lessons for machine use. Summaries and diagrams provide an accessible view for people, while detailed records retain definitions, sources, and discussion history. SQLite-based retrieval helps agents find relevant material.

## Orchestration and Continuity

I design how planning, implementation, and review are assigned to agents, including task boundaries, dependencies, the context passed to each agent, and how results return for review. Records connect this process across tasks and sessions, so later work can refer to earlier judgments and experience. I remain responsible for setting priorities, resolving questions, and making decisions as requirements change.

The [print-on-demand business systems project](https://github.com/marehaka/business-logic-to-ai-tasks) is one setting in which I develop and use these practices.

## Publication Status

The detailed case study and new examples are being revised. Earlier documents and samples have been withdrawn from the current version of this repository while that work is prepared.

## License

MIT. See [LICENSE](LICENSE).
