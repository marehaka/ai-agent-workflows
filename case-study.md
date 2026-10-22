# Building and Running AI Agent Workflows

English · [日本語](case-study.ja.md)

[Overview](README.md) · [Profile](https://github.com/marehaka/marehaka) · [Business Systems Case Study](https://github.com/marehaka/print-on-demand-business-systems/blob/main/case-study.md)

## Project Overview

I am developing an environment where a new agent can join a long-running project and recover the background needed to continue the work. It gives agents a way to consult earlier decisions and experience when needed. The project began as a personal assistant for my own activities. Since 2025, I have been saving conversations with AI and experimenting with information organization, retrieval, and task coordination.

This case study focuses on context management and the redesign of record processing, including their relationship to work coordination and review. It describes the project as of October 2026.

| Project Facts | Details |
| --- | --- |
| Purpose | Make earlier decisions, reasons, and experience available when needed in long-running work |
| My Contribution | Problem and requirements analysis, information and workflow design, implementation and verification with AI agents, and improvement through use |
| Core Tools | Python, SQLite, JSONL, Markdown, Git, and Claude Code skills and hooks |
| Use | Used in my own development environment. Related context-management practices are also used in business systems development |
| Current Boundary | Recorder has been adopted in my development environment. Rollout to other projects and evaluation of sustained benefits remain in progress |

## The Problem: Starting Again Without Starting Over

Something that is manageable within one session becomes harder over months of development. Requirements change, approaches are tried and abandoned, and earlier decisions reflect the constraints at the time. When a new agent started from the files and the current request alone, it could implement a change without understanding that background.

Handoffs and records of decisions and lessons helped. When I explicitly asked agents to read them, they could recover earlier decisions and continue the work. Yet mistakes still recurred as the records grew. Relevant information could be hard to retrieve, and some records were difficult to understand without knowing the original conversation.

## Design Decisions

### Context should be recoverable

I wanted agents to reach the necessary background even when a handoff was incomplete. I separate shared rules from project-specific information and combine directories, configuration, decision records, and retrieval. The aim is to let agents select information for the task rather than read every document at the start.

An earlier decision is not necessarily the right answer today. References to original conversations, relationships between decisions, and later changes need to be read alongside current requirements. The design distinguishes finding information from using it appropriately.

### Machine-readable records and human-readable views serve different needs

Records processed by agents need consistent fields, types, relationships, and sources. For human review, I focus on views that make changes and pending decisions clear. I therefore separate raw conversations, extracted records, the retrieval database, and human-facing views.

Raw JSONL conversation logs are the primary source. Extracted records and the SQLite index are derived data; human-readable Markdown is another view. This was not the structure from the beginning. It developed through revisions to a document-based approach.

![Information flows from original conversations through derived records and retrieval to the current task.](assets/context-path.svg)

*The diagram shows a path from records to relevant background. It does not imply that all information is loaded automatically for every task or demonstrate the benefits of consulting it.*

### Recording is a separate responsibility

Originally, the agent doing the work also compiled records at the end of a session. Producing and organizing those records became lengthy, leaving the agent responsible for both the working context and record processing. When I separated this responsibility into a dedicated Recorder, I also reconsidered whether the existing schema supported reuse.

This separation does not imply lower total cost. Assigning the work to a different agent and reducing processing or token use are separate questions. Recorder may consume more tokens.

## Recorder: From Conversation to Retrievable Records

![Recorder's six stages: normalize the source, select candidates, write records, check them, compare with existing records, then write and ingest them.](assets/recorder-pipeline.svg)

The pipeline separates agents' judgments about meaning from operations handled deterministically in code. Alongside selecting candidates and writing records, it compares them with existing records: whether they describe the same thing, are related, or change an earlier decision. I designed the structure to represent relationships and recurrence so that the same mistake would not simply accumulate under different names.

The redesign addressed more than consistent formatting. Evaluation considers whether an agent unfamiliar with the conversation can understand a record, whether the original evidence can be reached, and whether relevant candidates appear near the top of search results. Extraction is also evaluated against an AI-generated reference set. This revealed a limitation: when extraction and evaluation share the same preprocessing, an omitted message can disappear from both. Checking that a quotation exists in the source is also distinct from evaluating whether its meaning has been represented correctly.

## Coordination and Human Decisions

I define task scope and dependencies and separate responsibility for implementation, review, and recording. A report that work is complete is distinct from a decision to proceed with its use. Current procedures include code review before submitting changes and a separate agent's review and report after changes have entered `main`. The latter is a review after the change, rather than an approval gate before merging. The responsible agents and I decide how to address findings and when to resume use.

I set priorities and resolve open decisions, working with agents on design, implementation, and verification. Some operations depend on a person specifying what to process and when. Fully unattended operation is not a requirement for completion.

Role names and responsibilities have changed during development. Rather than present a fixed organization chart, I describe the boundaries of responsibility and judgment. Coordination across concurrent tasks and recovery from exceptions are areas where I am still organizing further operational examples.

## Development Path

The periods show areas of emphasis. I developed this alongside other work, rather than working on it full-time throughout.

| Period | Main Work and Learning |
| --- | --- |
| Jun–Aug 2025 | Conversation storage and database experiments, followed by an August RAG application. Code was implemented, but the application did not deliver the results I wanted, and that attempt stalled |
| Late 2025–Mar 2026 | Organized context through documents and directories. Developed shared rules, roles, and decision records while addressing management overhead and file-operation errors |
| Apr–Jun 2026 | Developed the harness, shared configuration, session startup and closing procedures, SQLite ingestion and retrieval, and the division of implementation and review responsibilities |
| Jul–Sep 2026 | Reconsidered the separation of source conversations, records, and views, along with Recorder's responsibilities, the schema, and processing stages; developed experiments and implementations |
| Oct 2026 | Adopted the revised Recorder in my development environment, migrated records to the production ledger, and continued use and adjustments |

## Outcomes and Current Focus

I have built a system for recording decisions and experience, retrieving them, and following references back to the original conversations, together with procedures for operating it. I have also recovered context in practice by explicitly asking agents to consult earlier decisions. I have not demonstrated sustained reductions in repeated mistakes or total cost, or stable rollout across all projects.

I am now looking at how records are consulted in actual work, what is missing when they are unhelpful, and the effort required for maintenance and review. The purpose is to support my own work, including simplifying the system to suit how it is used.

## Related Work

[Print-on-Demand Business Systems](https://github.com/marehaka/print-on-demand-business-systems/blob/main/case-study.md) describes my work connecting business knowledge, data, orders, production, and shipping. Its outcomes should not be attributed solely to this agent environment.

This repository contains design explanations and reflections suitable for publication. It does not include implementation code, raw conversations, customer records, or private work records.
