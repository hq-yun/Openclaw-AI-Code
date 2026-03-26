#!/bin/bash
# Test REAL Claude Code integration with AI Dev workflow

echo "🧪 Testing REAL Claude Code Integration"
echo "========================================="
echo ""

PROJECT_PATH="/home/huiquanyun/.openclaw/workspace/skills/ai-dev/examples/test-project"

if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ Test project not found!"
    exit 1
fi

cd "$PROJECT_PATH"

# Show current state
echo "📁 Current file:"
cat index.js
echo ""
echo "---"
echo ""

TASK="Add a new function 'multiply(a, b)' that returns the product of two numbers. Keep existing code style."

echo "🎯 Task for Claude Code: $TASK"
echo ""
echo "⏳ Spawning REAL Claude Code agent..."
echo ""

# Spawn Claude Code via OpenClaw sessions_spawn with ACP runtime
openclaw sessions spawn \
  --label "test-real-claude-$(date +%s)" \
  --runtime acp \
  --agent-id claude-code \
  --cwd "$PROJECT_PATH" \
  --mode session \
  --task "$TASK" \
  --timeout-seconds 180

echo ""
echo "✅ Claude Code session spawned!"
echo ""
echo "📊 Session will execute and modify index.js with the multiply function."
echo "Check the file after completion to verify AI implementation."
echo ""
echo "Expected result:"
echo "- index.js should have a new 'multiply(a, b)' function"
echo "- module.exports should include 'multiply'"
