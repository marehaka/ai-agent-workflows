# Building and Running AI Agent Workflows

[English](README.md) · 日本語

ソフトウェア開発や調査など、複数のプロジェクトでAIエージェントと仕事を進める環境を開発・利用しています。オーケストレーションと知識・コンテクスト管理を組み合わせ、それぞれのAgentが担当する仕事に必要な情報と判断の前提を使えるようにしています。

## Agent-First Information Design

Agentが必要な時に必要な情報を参照し、適切な作業の文脈を組み立てられることを目指しています。業務知識、作業記録、決定と理由、未解決の問い、学びを、機械が扱える構造で整理しています。人には要約・図で全体像を伝え、詳細な記録には定義・根拠・議論の経緯を残します。SQLiteによる検索は、Agentが関連情報を探すために使っています。

## Orchestration and Continuity

計画・実装・レビューをAgentにどう分担させるかを設計しています。作業の範囲と依存関係、各Agentへ渡す文脈、結果をレビューへ戻す流れまでを扱います。記録を通じてタスクやセッションをつなぎ、次の仕事が過去の判断や経験を参照できるようにしています。要件の変化に応じた優先順位の設定、疑問の解消、判断は私が担います。

[Print-on-Demandサービスの業務システム](https://github.com/marehaka/business-logic-to-ai-tasks/blob/main/README.ja.md)は、この方法を開発・利用している現場の一つです。

## Publication Status

詳細な事例と新しいサンプルは改訂中です。準備に合わせ、以前の詳細資料とサンプルは、このrepoの現行版から取り下げています。

## License

MIT。[LICENSE](LICENSE)を参照。
