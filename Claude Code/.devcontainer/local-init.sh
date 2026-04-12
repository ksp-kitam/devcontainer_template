#!/bin/bash

# =================================
# 事前準備
# =================================
# エラーが発生したらそこで処理を停止する
set -e
# プロジェクトルートのディレクトリを設定
project_root_dir=$PWD

# =================================
# 個人用の初期設定処理
# =================================

# ---- 何かあればここに記載する ----

# =================================
# claude codeの設定
#  1. nodejsがインストールされていないコンテナの場合はインストールを行う
#  2. claude codeのインストールを行う
#  3. コンテナにマウントされているClaudeの情報を.caludeディレクトリにリンクする
#  4. LineWorks channelプラグインの追加
#  5. CLAUDE.md の作成
# =================================
# 処理前にプロジェクトルートに移動しておく
cd "$project_root_dir"

# node jsがインストールされていなければインストール
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

# Claude Codeをインストール
echo "Claude Code をインストールしています。"
sudo npm install -g @anthropic-ai/claude-code

# Claude Code関連の環境変数があれば設定する
echo "Claude Code 関連の環境変数を設定しています。"
if [ -f "/opt/claude_settings/.env" ]; then
    source /opt/claude_settings/.env
else
    echo ".env が見つからないためスキップしました。"
fi

# Claude Codeの各種設定用のフォルダがあればホームディレクトリ配下にリンクする
echo ".claude ディレクトリをホームディレクトリにリンクしています。"
if [ ! -d "/opt/claude_settings/.claude" ]; then
    echo ".claude が見つからないため新規作成します。"
    sudo mkdir -p /opt/claude_settings/.claude
fi
sudo chmod 777 -R /opt/claude_settings/.claude
ln -sf /opt/claude_settings/.claude $HOME/.claude

echo ".claude.json ファイルをホームディレクトリにリンクしています。"
if [ ! -f "/opt/claude_settings/.claude.json" ]; then
    echo ".claude.json が見つからないため新規作成します。"
    sudo touch /opt/claude_settings/.claude.json
fi
sudo chmod 777 /opt/claude_settings/.claude.json
ln -sf /opt/claude_settings/.claude.json $HOME/.claude.json

# Lineworks channelのインストール
echo "Claude CodeのLineworks channelを追加しています。"
if [ -d "/opt/claude_settings/lineworks-channel" ]; then
    sudo cp -r /opt/claude_settings/lineworks-channel /lineworks-channel
    if [ -f "/opt/claude_settings/.claude-lineworks.json" ]; then
        sudo cp /opt/claude_settings/.claude-lineworks.json /lineworks-channel/.claude-lineworks.json
    else
        echo ".claude-lineworks.json が見つからないためスキップしました。"
    fi
    sudo chmod 777 -R /lineworks-channel
    npm --prefix /lineworks-channel install
else
    echo "lineworks-channel ディレクトリが見つからないためスキップしました。"
fi

# プロジェクトルートにCLAUDE.mdを作成する。
echo "CLAUDE.md を準備しています。"
if [ ! -f "CLAUDE.md" ]; then
    if [ -f "/opt/claude_settings/CLAUDE.md" ]; then
        cp /opt/claude_settings/CLAUDE.md ./CLAUDE.md
        echo "CLAUDE.md を作成しました！"
    else
        echo "CLAUDE.md が見つからないためスキップしました。"
    fi
else
    echo "CLAUDE.md は既に存在するためスキップしました。"
fi

echo "セットアップが完了しました！"
