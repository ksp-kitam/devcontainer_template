# VS Code Devcontainer テンプレート集

チーム共有の構成を汚さずに VS Code Devcontainer 環境へ導入するためのテンプレートリポジトリです。

開発チームで共有する `devcontainer.json` や `docker-compose.yml` には、プロジェクト共通の依存関係（言語、DB、ツールなど）のみを記述します。

一方で、開発者個人のローカル環境に依存する部分を分離・拡張できるように以下の仕組みで設計されています。

- **共通構成 (`docker-compose.yml`, `init.sh`)：**

    チーム全員で利用するベース環境。
  
- **個人構成 (`docker-compose.local.yml`, `local-init.sh`)：**

    個人の AI ツール設定やボリュームマウント。

## 📁 ディレクトリ構成

- **`Claude Code/`：**

    Claude Code を利用するための Devcontainer テンプレート。

    [Claude Codeディレクトリへ移動](https://github.com/ksp-kitam/devcontainer_template/tree/main/Claude%20Code)
  
- **`Gemini CLI/`：**

    Gemini CLI を利用するための Devcontainer テンプレート。

    [Gemini CLIディレクトリへ移動](https://github.com/ksp-kitam/devcontainer_template/tree/main/Gemini%20CLI)

## 🚀 使い方

各ディレクトリ配下の `README.md` を参照してください。

## 🛠️ 注意事項

`docker-compose.local.yml` および `local-init.sh` は、個人固有の情報を扱うため、

通常はプロジェクトの `.gitignore` に追加して管理外にすることを推奨します。
