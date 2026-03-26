#!/bin/bash

# 网站复刻助手 - 部署脚本
# 自动部署到 GitHub Pages

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$SCRIPT_DIR/dist"
GITHUB_REPO="https://github.com/hq-yun/Openclaw-AI-Code.git"
GITHUB_PAGES_URL="https://hq-yun.github.io/Openclaw-AI-Code/"

echo "=========================================="
echo "    网站复刻助手 - 部署脚本"
echo "=========================================="
echo ""

# 检查 git
if ! command -v git &> /dev/null; then
    echo "错误：未安装 git"
    exit 1
fi

# 创建 dist 目录
echo "[1/5] 准备分发目录..."
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

# 复制文件
echo "[2/5] 复制项目文件..."
cp -r "$SCRIPT_DIR"/* "$DIST_DIR/"
cp -r "$SCRIPT_DIR"/.* "$DIST_DIR/" 2>/dev/null || true

# 清理不必要的文件
echo "[3/5] 清理分发文件..."
rm -rf "$DIST_DIR/.git"
rm -f "$DIST_DIR/deploy.sh"
rm -rf "$DIST_DIR/dist"

# 初始化 git
echo "[4/5] 设置部署仓库..."
cd "$DIST_DIR"
git init -b main --quiet
git config user.email "deploy@websitecloner.local"
git config user.name "Website Cloner Deploy"

git add .
git commit -m "Deploy to GitHub Pages [ci skip]" --quiet 2>/dev/null || git commit -m "Initial deployment" --quiet

# 处理 gh-pages 分支
if git rev-parse gh-pages --verify &> /dev/null; then
    echo "[5/5] 更新 gh-pages 分支..."
    git checkout gh-pages --quiet 2>/dev/null || git checkout -b gh-pages --quiet
    
    find . -type f ! -path './.git/*' -delete
    git add .
    git commit -m "Update deployment [ci skip]" --quiet 2>/dev/null || true
    
    git checkout main --quiet 2>/dev/null || git checkout master --quiet
    git merge gh-pages --no-edit --quiet 2>/dev/null || true
    git checkout gh-pages --quiet
else
    echo "[5/5] 创建新的 gh-pages 分支..."
    git checkout -b gh-pages --quiet
fi

# 推送到远程仓库
echo ""
echo "推送到 GitHub..."
git remote add origin "$GITHUB_REPO" 2>/dev/null || true
git push origin gh-pages --force --quiet

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "  ✅ 部署成功！"
    echo "=========================================="
    echo ""
    echo "你的网站复刻助手已上线："
    echo "📍 $GITHUB_PAGES_URL"
    echo ""
else
    echo "⚠️ 推送失败，请检查网络连接和 GitHub 权限"
fi

echo ""
echo "部署完成！"
