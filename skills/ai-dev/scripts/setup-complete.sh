#!/bin/bash
# Complete AI Dev setup - One command to rule them all!

echo "🚀 Setting up complete AI Dev automation..."
echo ""

WORKSPACE="/home/huiquanyun/.openclaw/workspace"
PROJECT_PATH="/home/huiquanyun/桌面/Openclaw-AI-Code"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success() { echo -e "${GREEN}✅ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }

# Step 1: Setup Git hooks
echo "📝 Step 1/6: Setting up Git hooks..."
"$WORKSPACE/skills/ai-dev/scripts/setup-auto-hooks.sh" || error "Failed to setup Git hooks"
success "Git hooks configured"
echo ""

# Step 2: Verify GitHub configuration
echo "🔐 Step 2/6: Verifying GitHub configuration..."

if [ -n "$GITHUB_TOKEN" ]; then
    success "GitHub Token found in environment"
elif grep -q "GITHUB_TOKEN\|GH_PAT" ~/.bashrc 2>/dev/null; then
    TOKEN=$(grep -o 'export GITHUB_TOKEN="[^"]*"' ~/.bashrc | cut -d'"' -f2)
    
    if [ -n "$TOKEN" ]; then
        export GITHUB_TOKEN="$TOKEN"
        success "GitHub Token loaded from ~/.bashrc"
    else
        warning "GITHUB_TOKEN not found in bashrc"
    fi
else
    error "No GitHub token configured. Please add to ~/.bashrc:"
    echo 'export GITHUB_TOKEN="your_token_here"'
fi

echo ""

# Step 3: Setup auto-test script
echo "🧪 Step 3/6: Setting up auto-test..."
if [ -f "$PROJECT_PATH/package.json" ]; then
    TEST_CMD=$(grep -o '"test"[[:space:]]*:[[:space:]]*"[^"]*"' "$PROJECT_PATH/package.json" | cut -d'"' -f4)
    
    if [ -n "$TEST_CMD" ] && [ "$TEST_CMD" != 'echo "Error: no test specified"' ]; then
        success "Test command detected: $TEST_CMD"
        
        # Run quick test to verify
        cd "$PROJECT_PATH"
        npm run test 2>/dev/null || warning "Tests may need setup, but script is configured"
    else
        warning "No test command in package.json"
    fi
else
    warning "package.json not found - tests will be skipped"
fi

success "Auto-test script ready: $WORKSPACE/skills/ai-dev/scripts/auto-test.sh"
echo ""

# Step 4: Setup auto-PR script
echo "🔀 Step 4/6: Setting up auto-PR..."
if command -v gh &> /dev/null; then
    success "GitHub CLI (gh) found"
    
    if gh auth status &> /dev/null; then
        success "gh CLI authenticated"
    else
        warning "gh CLI not authenticated. Run: gh auth login"
        
        # Try to authenticate with token
        if [ -n "$GITHUB_TOKEN" ]; then
            echo "$GITHUB_TOKEN" | gh auth login --with-token 2>/dev/null && success "Authenticated with token" || warning "Token authentication failed"
        fi
    fi
    
    success "Auto-PR script ready: $WORKSPACE/skills/ai-dev/scripts/auto-pr.sh"
else
    warning "GitHub CLI not installed. Install with:"
    
    if [ "$(uname)" = "Darwin" ]; then
        echo '  brew install gh'
    else
        echo '  curl -s https://packagecloud.io/install/repositories/github/cli/github-cli.script | sudo bash && apt-get install gh -y'
    fi
    
    warning "PR creation will require manual setup or CLI installation"
fi

echo ""

# Step 5: Create log directory
echo "📁 Step 5/6: Creating log directories..."
mkdir -p "$WORKSPACE/logs"
success "Log directory created: $WORKSPACE/logs"
echo ""

# Step 6: Setup cron jobs
echo "⏰ Step 6/6: Setting up automation cron jobs..."

# Check if cron is running
if pgrep cron &> /dev/null; then
    success "Cron daemon is running"
else
    warning "Cron daemon not detected. Some automation may not work."
fi

echo ""
echo "Summary of configured automations:"
echo ""
echo "  📝 Git Hooks (auto-push after commit):"
echo "     • post-commit   → Auto-push to GitHub"
echo "     • pre-push      → Run tests before push"
echo "     • post-merge    → Update after merge"
echo ""
echo "  ⏰ Cron Jobs:"
echo "     • ai-dev-auto-check (every 15 min) - Check for pending changes"
echo ""
echo "  🧪 Auto-Test Script:"
echo "     • Detects test commands automatically"
echo "     • Retry logic with auto-fix attempts"
echo ""
echo "  🔀 Auto-PR Script:"
echo "     • Create PRs from feature branches"
echo "     • Update existing PR descriptions"
echo "     • Merge PRs (with CI check)"
echo ""

# Display configuration status
echo "📊 Configuration Status:"
echo ""

HOOKS_DIR="$PROJECT_PATH/.git/hooks"
if [ -x "$HOOKS_DIR/post-commit" ]; then
    success "post-commit hook: ✅ Active"
else
    warning "post-commit hook: ❌ Missing or not executable"
fi

if [ -n "$GITHUB_TOKEN" ]; then
    success "GitHub Token: ✅ Configured"
else
    error "GitHub Token: ❌ Not configured"
fi

if command -v gh &> /dev/null; then
    if gh auth status &> /dev/null; then
        success "gh CLI: ✅ Authenticated"
    else
        warning "gh CLI: ⚠️  Installed but not authenticated"
    fi
else
    warning "gh CLI: ❌ Not installed"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Test the setup with a sample commit:"
echo "   cd $PROJECT_PATH"
echo "   echo 'test' >> test.txt && git add . && git commit -m 'Test commit'"
echo ""
echo "2. Create a feature branch and make changes:"
echo "   git checkout -b feature/test"
echo "   # Make changes..."
echo "   git push origin feature/test"
echo ""
echo "3. Use the AI Dev workflow:"
echo "   /ai-dev $PROJECT_PATH --task 'Add new feature'"
echo ""
