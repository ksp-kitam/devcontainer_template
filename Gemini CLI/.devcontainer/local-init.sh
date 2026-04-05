#!/bin/bash

# エラーが発生したらそこで処理を停止する
set -e

# =================================
# Gemini CLI の設定
#  1. nodejsがインストールされていないコンテナの場合はインストールを行う
#  2. Gemini CLI のインストールを行う
#  3. コンテナにマウントされている Gemini CLI の情報を .gemini ディレクトリにリンクする
#  4. GEMINI.md の作成
# =================================
echo "node jsをインストールしています..."
if command -v node >/dev/null 2>&1; then
    echo "Node.js は既にインストールされています: $(node -v)"
else
    # 存在しない場合はインストール処理を実行
    echo "Node.js が見つかりません。インストールします..."
    sudo apt-get update
    sudo apt-get install nodejs
    echo "Node.js のインストールが完了しました: $(node -v)"
fi

echo "Gemini CLI をインストールしています..."
npm install -g @google/gemini-cli
source /opt/gemini_settings/.env

echo "Gemini CLI の認証情報をホームディレクトリにリンクしています..."
ln -sf /opt/gemini_settings/.gemini $HOME/.gemini
ln -sf /opt/gemini_settings/.gemini.json $HOME/.gemini.json

echo "GEMINI.md を準備しています..."
if [ ! -f "GEMINI.md" ]; then
  cp /opt/gemini_settings/GEMINI.md ./GEMINI.md
  echo "GEMINI.md を作成しました！"
else
  echo "GEMINI.md は既に存在するためスキップしました。"
fi

echo "セットアップが完了しました！"
