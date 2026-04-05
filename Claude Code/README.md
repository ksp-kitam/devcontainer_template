# VS Code Devcontainer テンプレート

VS CodeのDevcontainerを利用して、任意の開発言語環境を迅速に構築するためのテンプレートです。

本テンプレートでは、AIコーディングアシスタント「[Claude Code](https://github.com/anthropics/claude-code)」などの個人的な開発支援ツールは、

チームで共有する共通環境には含めない方針としています。

Claude Codeのインストールや認証情報の連携は、開発者個人のローカル環境固有の設定（`local-init.sh` および `docker-compose.local.yml`）でのみ行い、

チームのリポジトリをクリーンに保ちます。

## 🌟 特徴

* **柔軟な開発環境の選択**: デフォルトは汎用的な Debian ベースイメージですが、設定ファイルのコメントを切り替えるだけで Java, Python, Node.js などの環境へ簡単に変更可能です。
* **ローカル・オーバーライド設計**: `docker-compose.local.yml` や `local-init.sh` を用いて、チームの共通環境を汚さずに個人の環境（Claude Codeの導入やボリュームマウントなど）を拡張できます。

## 📁 ディレクトリ構成

プロジェクトに本テンプレートを導入する場合、以下のように `.devcontainer` フォルダ内に配置します。

```text
.devcontainer/
 ├── devcontainer.json        # Devcontainerのメイン設定ファイル（チーム共有）
 ├── docker-compose.yml       # 共通のコンテナ構成（ベース / チーム共有）
 ├── init.sh                  # コンテナビルド後の共通初期化スクリプト（チーム共有）
 ├── docker-compose.local.yml # 個人環境用の構成（Claude Code設定等 / ※Git管理外）
 └── local-init.sh            # 個人環境用の初期化スクリプト（Claude Codeインストール等 / ※Git管理外）
```
※ 利用する場合は、`.gitignore` に `docker-compose.local.yml` と `local-init.sh` を必ず追加してください。

## 🚀 セットアップ手順

### 1. 前提条件

Docker Desktop または Docker Engine がインストールされ、起動していること。

VS Code に拡張機能 Dev Containers がインストールされていること。

### 2. 開発言語の選択（必要に応じて / チーム共通設定）

docker-compose.yml を開き、プロジェクトの開発言語に合わせて image: の指定を変更します。

デフォルトはDebianベースですが、使用したい言語のコメント（#）を外すだけで切り替えられます。

```yaml
# docker-compose.yml の抜粋
services:
  app:
    # 使用する言語に合わせて、いずれか1つのコメントを外してください
    image: [mcr.microsoft.com/devcontainers/base:debian](https://mcr.microsoft.com/devcontainers/base:debian)
    #image: [mcr.microsoft.com/devcontainers/java](https://mcr.microsoft.com/devcontainers/java)
    #image: [mcr.microsoft.com/devcontainers/python:3](https://mcr.microsoft.com/devcontainers/python:3)
    #image: [mcr.microsoft.com/devcontainers/javascript-node](https://mcr.microsoft.com/devcontainers/javascript-node)
```

### 3. 個人用環境のパス修正（Claude Codeを利用する個人のみ）

docker-compose.local.yml を開き、ホスト側の Claude Code 設定ディレクトリのパスを自身の環境に合わせて変更してください。

```yaml
# docker-compose.local.yml の修正箇所
services:
  app:
    volumes:
      # 【変更前】 /home/kitam/workspace/01_claude
      # 【変更後】 あなたのPCの Claude Code 関連ファイルがある絶対パスに書き換える
      - /path/to/your/local/claude_settings:/opt/claude_settings:cached
```
※ 注意: マウント元のディレクトリには以下のファイル/フォルダが含まれていることを前提としています。
- .claude / .claude.json (認証情報)
- .mcp.json (MCP設定)
- lineworks-channel/ (Lineworks連携用：[詳しくはコチラを参照ください](https://github.com/ksp-gikai-ojt/claude-code-lineworks-channel) )
- CLAUDE.md (プロジェクトのプロンプト・ガイドライン)

### 4. コンテナの起動

- VS Codeでこのプロジェクトを開きます。

- Dev Containers を実行します。

- 初回ビルドと初期化スクリプトが実行され、開発環境が立ち上がります。

## 💻 使い方

コンテナの起動が完了すると、VS Codeのウィンドウがコンテナ内のファイルシステムに接続された状態になります。

### 通常の開発

- VS Codeの上部メニューから 「ターミナル」 > 「新しいターミナル」（ショートカット: <code>Ctrl + `</code>）を開きます。

- 開いたターミナルは既にコンテナ内部（選択した言語環境）にアクセスしているため、node, python, java などのコマンドをすぐに実行できます。

- ローカルPCと同じ感覚でコードを編集・保存・実行してください。変更内容はホスト側と同期されます。

### Claude Code の利用（設定済みの場合）

- local-init.sh でのセットアップが完了している場合、ターミナルからすぐにClaude Codeを呼び出せます。

- コンテナ内のターミナルを開きます。

- 以下のコマンドを実行してClaude Codeを起動します。
  ```bash
  claude
  ```

- ターミナル上で対話型のインターフェースが起動し、コードの解説、生成、リファクタリングなどをAIに依頼できます。
