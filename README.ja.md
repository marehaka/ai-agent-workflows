# Building and Running AI Agent Workflows

[English](README.md) · 日本語

[プロフィール](https://github.com/marehaka/marehaka/blob/main/README.ja.md) · [Business Systems](https://github.com/marehaka/print-on-demand-business-systems/blob/main/README.ja.md) · [Case Study](case-study.ja.md)

AIエージェントと長期の仕事を続けるために、作業の分担、知識の整理、必要な文脈の取得を支える環境を開発・利用しています。新しいセッションのAgentが、過去に何を決め、なぜそう判断し、何が未解決なのかを把握して作業できることを目指しています。

**My Contribution:** 課題と要件の整理、情報構造と作業手順の設計、AIを使った実装、結果の確認と運用改善  
**Core Tools:** Python、SQLite、JSONL、Markdown、Git、Claude CodeのSkill・Hook  
**Context:** 自分の継続的な仕事を支えるための開発。2025年の試行から現在まで

## The Problem

長期の開発では、Agentが交代するたびに判断の背景が抜け、古い前提で実装したり、同じ説明や修正を繰り返したりする問題がありました。会話や判断を保存するだけでは、必要な情報が検索で届き、現在の仕事に使われるとは限りませんでした。

## What I Built

- **Context and knowledge:** プロジェクト固有の情報と共通手順を分け、判断・理由・未解決の問い・学びを整理。検索と原文への参照を通じて、Agentが必要な背景へ辿れる経路を作っています。
- **Recording and retrieval:** 作業を進めるAgentから記録処理を分離し、専任のRecorderを開発。抽出、検査、過去の記録との照合、書込みを分け、SQLiteで検索できる形へつなぎました。
- **Work coordination:** 仕事の範囲、依存関係、実装と検収の責任、判断を人へ戻す条件を整理しています。優先順位と未解決の判断は私が担い、役割と手順は運用上の問題に合わせて見直しています。

![会話原文から構造化した記録、検索、作業の文脈へ進む経路。現在の要件と人の判断も必要。](assets/context-path.svg)

## What Has Changed

過去の判断を明示的に参照させることで、背景を復元し、仕事を続ける手応えを得てきました。一方、同じ失敗の反復や検索の不足は残り、記録の構造と処理を再設計しました。改修したRecorderは2026年10月に、この開発環境で正式採用しています。

現在は実際の仕事での再利用と維持負担を確認しています。継続的な再発防止、時間短縮、総費用の削減を実証済みとはしていません。

[Case Study](case-study.ja.md)では、目的が一貫する中で実現方法をどう変えたか、Recorderの設計、作業と判断の分担を説明しています。[Print-on-Demandの業務システム](https://github.com/marehaka/print-on-demand-business-systems/blob/main/case-study.ja.md)は、関連する文脈管理の実践を行っている仕事の一つです。

## Scope and License

このrepoは設計と実践を説明するCase Studyです。実装コード、生の会話、私的な作業記録は含みません。MIT。[LICENSE](LICENSE)を参照。
