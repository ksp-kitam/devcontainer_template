#!/bin/bash

# エラーが発生したらそこで処理を停止する
set -e

# =================================
# Open Code の設定
#  1. nodejsがインストールされていないコンテナの場合はインストールを行う
#  2. Open Code のインストールを行う
# =================================
echo "node jsをインストールしています。"
if command -v node >/dev/null 2>&1; then
    echo "Node.js は既にインストールされています: $(node -v)"
else
    # 存在しない場合はインストール処理を実行
    echo "Node.js が見つかりません。インストールします。"
    sudo apt-get update
    sudo apt-get install -y nodejs
    sudo apt-get install -y npm
    echo "Node.js のインストールが完了しました: $(node -v)"
fi

echo "Open Code をインストールしています。"
sudo npm i -g opencode-ai@latest

echo "Open Code 関連の環境変数を設定しています。"
if [ -f "/opt/opencode_settings/.env" ]; then
    source /opt/opencode_settings/.env
else
    echo ".env が見つからないためスキップしました。"
fi

echo "opencode.json ファイルをホームディレクトリにリンクしています。"
if [ ! -f "/opt/opencode_settings/opencode.json" ]; then
    echo "opencode.json が見つからないため新規作成します。"
    sudo touch /opt/opencode_settings/opencode.json
fi
sudo chmod 777 /opt/opencode_settings/opencode.json
mkdir -p $HOME/.config/opencode
ln -sf /opt/claude_settings/.claude.json $HOME/.config/opencode/opencode.json

echo "セットアップが完了しました！"
