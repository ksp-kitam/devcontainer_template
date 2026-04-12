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
# Gemini CLI の設定
#  1. nodejsがインストールされていないコンテナの場合はインストールを行う
#  2. Gemini CLI のインストールを行う
#  3. コンテナにマウントされている Gemini CLI の情報を .gemini ディレクトリにリンクする
#  4. GEMINI.md の作成
# =================================
# 処理前にプロジェクトルートに移動しておく
cd "$project_root_dir"

# node jsがインストールされていなければインストール
echo "node jsをインストールしています..."
if command -v node >/dev/null 2>&1; then
    echo "Node.js は既にインストールされています: $(node -v)"
else
    # 存在しない場合はインストール処理を実行
    echo "Node.js が見つかりません。インストールします..."
    sudo apt-get update
    sudo apt-get install -y nodejs
    sudo apt-get install -y npm
    echo "Node.js のインストールが完了しました: $(node -v)"
fi

# Gemini CLIをインストール
echo "Gemini CLI をインストールしています。"
sudo npm install -g @google/gemini-cli

# Gemini CLI関連の環境変数があれば設定する
echo "Gemini CLI 関連の環境変数を設定しています。"
if [ -f "/opt/gemini_settings/.env" ]; then
    source /opt/gemini_settings/.env
else
    echo ".env が見つからないためスキップしました。"
fi

# Gemini CLIの各種設定用のフォルダがあればホームディレクトリ配下にリンクする
echo ".geminiディレクトリをホームディレクトリにリンクしています。"
if [ ! -d "/opt/gemini_settings/.gemini" ]; then
    echo ".gemini が見つからないため新規作成します。"
    sudo mkdir -p /opt/gemini_settings/.gemini
fi
sudo chmod 777 -R /opt/gemini_settings/.gemini
ln -sf /opt/gemini_settings/.gemini $HOME/.gemini

# プロジェクトルートにGEMINI.mdを作成する。
echo "GEMINI.md を準備しています..."
if [ ! -f "GEMINI.md" ]; then
    if [ -f "/opt/gemini_settings/GEMINI.md" ]; then
        cp /opt/gemini_settings/GEMINI.md ./GEMINI.md
        echo "GEMINI.md を作成しました！"
    else
        echo "コピー元の GEMINI.md が見つからないためスキップしました。"
    fi
else
    echo "GEMINI.md は既に存在するためスキップしました。"
fi

echo "セットアップが完了しました！"
