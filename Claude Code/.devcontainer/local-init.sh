#!/bin/bash

# エラーが発生したらそこで処理を停止する
set -e

# =================================
# claude codeの設定
#  1. nodejsがインストールされていないコンテナの場合はインストールを行う
#  2. claude codeのインストールを行う
#  3. コンテナにマウントされているClaudeの情報を.caludeディレクトリにリンクする
#  4. LineWorks channelプラグインの追加
#  5. CLAUDE.md の作成
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

echo "Claude Codeをインストールしています..."
npm install -g @anthropic-ai/claude-code

echo "Claude Codeの認証情報をホームディレクトリにリンクしています..."
ln -sf /opt/claude_settings/.claude $HOME/.claude
ln -sf /opt/claude_settings/.claude.json $HOME/.claude.json
ln -sf /opt/claude_settings/.mcp.json .mcp.json

echo "Claude CodeのLineworks channelを追加しています.."
sudo cp -r /opt/claude_settings/lineworks-channel /lineworks-channel
sudo cp /opt/claude_settings/.claude-lineworks.json /lineworks-channel/.claude-lineworks.json
sudo chmod 777 -R /lineworks-channel
npm --prefix /lineworks-channel install

echo "CLAUDE.md を準備しています..."
if [ ! -f "CLAUDE.md" ]; then
  cp /opt/claude_settings/CLAUDE.md ./CLAUDE.md
  echo "CLAUDE.md を作成しました！"
else
  echo "CLAUDE.md は既に存在するためスキップしました。"
fi


echo "セットアップが完了しました！"
