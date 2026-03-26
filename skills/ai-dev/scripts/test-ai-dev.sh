#!/bin/bash
# Test AI Dev workflow with a sample project

echo "🧪 Testing AI Dev Workflow"
echo "=========================="

PROJECT_PATH="/home/huiquanyun/.openclaw/workspace/skills/ai-dev/examples/test-project"

if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ Test project not found at $PROJECT_PATH"
    exit 1
fi

cd "$PROJECT_PATH"

echo "📁 Testing in: $(pwd)"
echo ""

# Step 1: Check if git is initialized
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    git remote add origin https://github.com/test/test-repo.git || true
fi

# Step 2: Create a simple task
TASK="Add a new function 'add(a, b)' that returns the sum of two numbers"

echo "🎯 Task: $TASK"
echo ""

# Step 3: Run AI Dev (simplified for testing)
echo "🚀 Spawning AI agent..."

cd /home/huiquanyun/.openclaw/workspace/skills/ai-dev/scripts

cat > /tmp/test-task.json <<EOF
{
  "project_path": "$(realpath $PROJECT_PATH)",
  "task": "$TASK",
  "test_cmd": "npm test",
  "timestamp": "$(date +%Y%m%d%H%M%S)"
}
EOF

# Spawn Claude Code agent
openclaw sessions spawn \
  --label "ai-dev-test-$(date +%s)" \
  --runtime acp \
  --agent-id claude-code \
  --task "Complete this development task: $(cat /tmp/test-task.json)" \
  --cwd "$PROJECT_PATH" \
  --mode session \
  --timeout-seconds 180

echo ""
echo "✅ Test workflow initiated!"
echo "📊 Check the spawned session for results."

# Cleanup
rm -f /tmp/test-task.json
