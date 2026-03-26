#!/bin/bash
# Auto-setup Git hooks for automatic pushing

echo "🔧 Setting up auto-push Git hooks..."

HOOKS_DIR="/home/huiquanyun/桌面/Openclaw-AI-Code/.git/hooks"
WORKSPACE="/home/huiquanyun/.openclaw/workspace"

# Create post-commit hook
cat > "$HOOKS_DIR/post-commit" <<'EOF'
#!/bin/bash
# Auto-push to GitHub after every commit

cd /home/huiquanyun/桌面/Openclaw-AI-Code

echo "🚀 Auto-pushing changes..."

# Check if there are unpushed commits
if git rev-parse --verify origin/main >/dev/null 2>&1; then
    local_commits=$(git log --oneline origin/main..HEAD | wc -l)
    
    if [ "$local_commits" -gt 0 ]; then
        git push origin main 2>&1 && echo "✅ Pushed $local_commits commit(s)" || echo "❌ Push failed"
    fi
else
    # First time setup
    git push -u origin main 2>&1 && echo "✅ Initial push complete!" || echo "❌ Push failed"
fi

# Trigger AI Dev check if there are changes
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  There are uncommitted changes in workspace"
fi
EOF

chmod +x "$HOOKS_DIR/post-commit"

# Create post-merge hook (auto-pull after merge)
cat > "$HOOKS_DIR/post-merge" <<'EOF'
#!/bin/bash
# Auto-update after pull/merge

cd /home/huiquanyun/桌面/Openclaw-AI-Code

echo "🔄 Post-merge update..."

# Update submodules if exist
if [ -d ".git/modules" ]; then
    git submodule update --recursive --init 2>/dev/null || true
fi

# Run post-merge checks
echo "✅ Merge complete!"
EOF

chmod +x "$HOOKS_DIR/post-merge"

# Create pre-push hook (auto-test before push)
cat > "$HOOKS_DIR/pre-push" <<'EOF'
#!/bin/bash
# Auto-run tests before pushing

cd /home/huiquanyun/桌面/Openclaw-AI-Code

echo "🧪 Running pre-push checks..."

# Check for package.json test command
if [ -f "package.json" ]; then
    TEST_CMD=$(grep -o '"test"[[:space:]]*:[[:space:]]*"[^"]*"' package.json | cut -d'"' -f4)
    
    if [ -n "$TEST_CMD" ] && [ "$TEST_CMD" != "echo \"Error: no test specified\"" ]; then
        echo "Running tests: $TEST_CMD"
        npm run test 2>&1
        
        if [ $? -ne 0 ]; then
            echo "❌ Tests failed! Aborting push."
            exit 1
        fi
    fi
fi

echo "✅ Pre-push checks passed!"
EOF

chmod +x "$HOOKS_DIR/pre-push"

# Create post-receive hook (for server-side auto-deploy if needed)
cat > "$HOOKS_DIR/post-receive" <<'EOF'
#!/bin/bash
# Auto-trigger after push to GitHub

echo "📬 Received push notification"

# Log the event
echo "$(date): Push received to main branch" >> /tmp/git-hooks.log

# Optional: Trigger CI/CD or other automation here
# curl -X POST https://your-ci-webhook.com/trigger
EOF

chmod +x "$HOOKS_DIR/post-receive"

echo ""
echo "✅ Git hooks configured!"
echo ""
echo "Hooks created:"
echo "  • post-commit   → Auto-push after commit"
echo "  • pre-push      → Run tests before push"  
echo "  • post-merge    → Update after merge"
echo "  • post-receive  → Trigger automation"
echo ""
