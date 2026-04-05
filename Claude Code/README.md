# VS Code Devcontainer テンプレート (Claude Code連携)

VS CodeのDevcontainerを利用して、AIコーディングアシスタント「[Claude Code](https://github.com/anthropics/claude-code)」の環境を迅速に構築するためのテンプレートです。

チーム共通の設定（ベース）と、開発者個人のローカル環境固有の設定（ローカルオーバーライド）を分離して管理できる設計になっています。

## 🌟 特徴

* **開発環境の即時構築**: Microsoft公式のDevcontainerイメージを利用。
* **Claude Codeの自動セットアップ**: コンテナ起動時に自動でインストールされ、ホスト側の認証情報やMCP設定、Lineworksチャンネル設定をシームレスに引き継ぎます。
* **ローカル・オーバーライド設計**: `docker-compose.local.yml` や `local-init.sh` を用いて、チームの共通環境を汚さずに個人の環境（ボリュームマウントや追加パッケージなど）を拡張可能です。

## 📁 ディレクトリ構成

プロジェクトに本テンプレートを導入する場合、以下のように `.devcontainer` フォルダ内に配置します。

```text
.devcontainer/
 ├── devcontainer.json        # Devcontainerのメイン設定ファイル
 ├── docker-compose.yml       # 共通のコンテナ構成（ベース）
 ├── docker-compose.local.yml # 個人環境用の構成（ローカルマウント等 / ※Git管理外推奨）
 ├── init.sh                  # コンテナビルド後の共通初期化スクリプト
 └── local-init.sh            # 個人環境用の初期化スクリプト（Node.js/Claude Code設定 / ※Git管理外推奨）
