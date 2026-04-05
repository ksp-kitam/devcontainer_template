# VS Code Devcontainer テンプレート集

チーム共有の構成を汚さずに VS Code Devcontainer 環境へ導入するためのテンプレートリポジトリです。

開発チームで共有する `devcontainer.json` や `docker-compose.yml` には、プロジェクト共通の依存関係（言語、DB、ツールなど）のみを記述します。

一方で、Claude Code や Gemini CLI などの AI ツールのインストールや認証情報の連携は、開発者個人のローカル環境に依存するため、

以下の仕組みで分離・拡張できるように設計されています。

*   **共通構成 (`docker-compose.yml`, `init.sh`)**: チーム全員で利用するベース環境。
*   **個人構成 (`docker-compose.local.yml`, `local-init.sh`)**: 個人の AI ツール設定やボリュームマウント。

## 📁 ディレクトリ構成

*   **`Claude Code/`**: [Claude Code](https://github.com/anthropics/claude-code) を利用するための Devcontainer テンプレート。
*   **`Gemini CLI/`**: [Gemini CLI](https://github.com/google-gemini/gemini-cli) を利用するための Devcontainer テンプレート。
*   **`.devcontainer/`**: 実際に VS Code で使用される設定ディレクトリ。利用したいアシスタントのテンプレートをここにコピーして使用します。

## 🚀 使い方

### 1. アシスタントの選択と配置

利用したい環境名のディレクトリ内にある `.devcontainer/` の中身を、プロジェクトルートの `.devcontainer/` ディレクトリにコピーします。

### 2. 開発言語の選択（チーム共通設定）

`.devcontainer/docker-compose.yml` を開き、使用したいプログラミング言語のベースイメージのコメントアウトを外します。

```yaml
services:
  app:
    image: mcr.microsoft.com/devcontainers/base:debian # デフォルト
    # image: mcr.microsoft.com/devcontainers/python:3   # Pythonの場合
```

### 3. 個人用設定の修正（個人設定）
`.devcontainer/docker-compose.local.yml` を開き、自分の PC の環境に合わせて修正します。

*   **Claude Code の場合**: `~/.claude` などが含まれるディレクトリ
*   **Gemini CLI の場合**: `~/.gemini` などが含まれるディレクトリ

### 4. コンテナの起動
VS Code でプロジェクトを開き、コマンドパレットから `Dev Containers: Reopen in Container` を実行します。

起動時に `local-init.sh` が自動的に実行されます。

## 🛠️ 注意事項
*   `docker-compose.local.yml` および `local-init.sh` は、個人固有の情報を扱うため、通常はプロジェクトの `.gitignore` に追加して管理外にすることを推奨します。
