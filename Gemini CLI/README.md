# VS Code Devcontainer Gemini CLI テンプレート

VS CodeのDevcontainerを利用して、任意の開発言語環境を迅速に構築するためのテンプレートです。

本テンプレートでは、AIコーディングアシスタント「[Gemini CLI](https://github.com/google-gemini/gemini-cli)」などの個人的な開発支援ツールは、

チームで共有する共通環境には含めない方針としています。

Gemini CLIのインストールや認証情報の連携は、開発者個人のローカル環境固有の設定（`local-init.sh` および `docker-compose.local.yml`）でのみ行い、

チームのリポジトリをクリーンに保ちます。

## 🌟 特徴

* **柔軟な開発環境の選択**: デフォルトは汎用的な Debian ベースイメージですが、設定ファイルのコメントを切り替えるだけで Java, Python, Node.js などの環境へ簡単に変更可能です。
* **ローカル・オーバーライド設計**: `docker-compose.local.yml` や `local-init.sh` を用いて、チームの共通環境を汚さずに個人の環境（Gemini CLIの導入やボリュームマウントなど）を拡張できます。

## 📁 ディレクトリ構成

プロジェクトに本テンプレートを導入する場合、以下のように `.devcontainer` フォルダ内に配置します。

```text
.devcontainer/
 ├── devcontainer.json        # Devcontainerのメイン設定ファイル（チーム共有）
 ├── docker-compose.yml       # 共通のコンテナ構成（ベース / チーム共有）
 ├── init.sh                  # コンテナビルド後の共通初期化スクリプト（チーム共有）
 ├── docker-compose.local.yml # 個人環境用の構成（Gemini CLI設定等 / 個人固有）
 └── local-init.sh            # 個人環境用の初期化スクリプト（Gemini CLIインストール等 / 個人固有）
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

docker-compose.local.yml を開き、ホスト側の Gemini CLI 設定ディレクトリのパスを自身の環境に合わせて変更してください。

```yaml
# docker-compose.local.yml の修正箇所
services:
  app:
    volumes:
      # マウント元(ローカル側)を Gemini CLI の管理情報の保存場所に書き換える
      # コンテナ側の<ホームディレクトリ>/.geminiに設定される。
      - <your pc gemini cli data folder>:/opt/gemini_settings:cached
```
※ 注意: マウント元のディレクトリには以下のファイル/フォルダが含まれていることを前提としています。
- .gemini / .gemini.json (認証情報)
- GEMINI.md (プロジェクトのプロンプト・ガイドライン)

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

### Gemini CLI の利用（設定済みの場合）

- local-init.sh でのセットアップが完了している場合、ターミナルからすぐに Gemini CLI を呼び出せます。

- コンテナ内のターミナルを開きます。

- 以下のコマンドを実行して Gemini CLI を起動します。
  ```bash
  gemini
  ```

- ターミナル上で対話型のインターフェースが起動し、コードの解説、生成、リファクタリングなどをAIに依頼できます。
