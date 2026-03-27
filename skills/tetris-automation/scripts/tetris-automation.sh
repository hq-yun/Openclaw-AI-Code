#!/bin/bash

# Tetris Automation Script
# Full workflow: Claude Code → Test → Commit → Push → Deploy

set -e

PROJECT_DIR="/home/huiquanyun/桌面/Openclaw-AI-Code"
GITHUB_REPO="https://github.com/hq-yun/Openclaw-AI-Code.git"
GITHUB_PAGES_URL="https://hq-yun.github.io/Openclaw-AI-Code/"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "    Tetris Automation Workflow"
echo "=========================================="
echo ""

# Check if modification description is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Please provide a modification description.${NC}"
    echo "Usage: $0 \"[modification description]\""
    echo ""
    echo "Examples:"
    echo "  $0 \"fix: correct ghost piece rendering artifacts\""
    echo "  $0 \"feat: add sound effects for line clear\""
    echo "  $0 \"perf: optimize canvas rendering loop\""
    exit 1
fi

MODIFICATION="$1"

# Step 1: Spawn Claude Code to make modifications
echo -e "${YELLOW}[Step 1/5] Spawning Claude Code agent...${NC}"
echo "Task: $MODIFICATION"
echo ""

# Use sessions_spawn to run Claude Code
sessions_spawn \
    --task "$MODIFICATION" \
    --runtime acp \
    --agentId claude-code \
    --cwd "$PROJECT_DIR" \
    --mode session \
    --thread false \
    --timeoutSeconds 300

echo -e "${GREEN}✅ Claude Code agent started.${NC}"
echo "   Waiting for completion..."
echo ""

# Wait for Claude Code to complete (polling)
sleep 10
while true; do
    STATUS=$(subagents action=list 2>/dev/null | grep -c "claude-code" || echo "0")
    if [ "$STATUS" = "0" ]; then
        break
    fi
    sleep 5
done

echo -e "${GREEN}✅ Claude Code completed.${NC}"
echo ""

# Step 2: Verify file integrity
echo -e "${YELLOW}[Step 2/5] Verifying file integrity...${NC}"

REQUIRED_FILES=("index.html" "css/style.css" "js/game.js" "js/pieces.js" "README.md")
MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$PROJECT_DIR/$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo -e "${RED}❌ Error: Missing required files:${NC}"
    for file in "${MISSING_FILES[@]}"; do
        echo "   - $file"
    done
    exit 1
fi

echo -e "${GREEN}✅ All required files present.${NC}"
echo ""

# Step 3: Git commit
echo -e "${YELLOW}[Step 3/5] Creating Git commit...${NC}"

cd "$PROJECT_DIR"

# Extract type from modification description (feat, fix, docs, etc.)
MOD_TYPE=$(echo "$MODIFICATION" | grep -oE "^(feat|fix|docs|style|refactor|perf|test|chore):" || echo "feat:")

if [ -z "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}⚠️  No changes to commit.${NC}"
else
    git add .
    
    # Extract description after the type prefix
    MOD_DESC=$(echo "$MODIFICATION" | sed 's/^[^:]*://')
    
    git commit -m "$MODIFICATION"
    
    echo -e "${GREEN}✅ Commit created: $MODIFICATION${NC}"
fi

echo ""

# Step 4: Push to GitHub
echo -e "${YELLOW}[Step 4/5] Pushing to GitHub...${NC}"

git push origin main

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Successfully pushed to $GITHUB_REPO${NC}"
else
    echo -e "${RED}❌ Failed to push to GitHub.${NC}"
    exit 1
fi

echo ""

# Step 5: Deploy to GitHub Pages
echo -e "${YELLOW}[Step 5/5] Deploying to GitHub Pages...${NC}"

./deploy.sh

cd dist

# Add remote if not exists
if ! git remote get-url origin &>/dev/null; then
    git remote add origin "$GITHUB_REPO"
fi

git push origin gh-pages --force

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo -e "${GREEN}🎉 Automation Workflow Complete!${NC}"
    echo "=========================================="
    echo ""
    echo -e "Summary:"
    echo "  📝 Modification: $MODIFICATION"
    echo "  🔄 Code modified by: Claude Code agent"
    echo "  ✅ Git commit created"
    echo "  🚀 Pushed to GitHub"
    echo "  🌐 Deployed to GitHub Pages"
    echo ""
    echo -e "📍 Live URL: $GITHUB_PAGES_URL"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Visit the live URL to test changes"
    echo "  2. Verify functionality in browser"
    echo "  3. Report any issues if found"
    echo ""
else
    echo -e "${RED}❌ Failed to deploy to GitHub Pages.${NC}"
    exit 1
fi
