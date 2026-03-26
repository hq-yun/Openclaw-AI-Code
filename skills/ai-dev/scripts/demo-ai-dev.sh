#!/bin/bash
# Demo: AI Dev workflow in action

echo "🚀 AI Code Development Workflow - Demo"
echo "======================================="
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

# Simulate AI task execution
TASK="Add a new function 'add(a, b)' that returns the sum of two numbers"

echo "🎯 Task: $TASK"
echo ""

# Create modified version (simulating AI output)
cat > index.js <<'EOF'
// Test project for AI Dev workflow
function greet(name) {
  return `Hello, ${name}!`;
}

function add(a, b) {
  return a + b;
}

module.exports = { greet, add };
EOF

echo "✅ AI Agent completed changes!"
echo ""
echo "📝 Modified file:"
cat index.js
echo ""
echo "---"
echo ""

# Test the code
echo "🧪 Running test..."
node -e "const {add} = require('./index.js'); console.log('add(2, 3) =', add(2, 3)); if(add(2, 3) === 5) console.log('✅ Test passed!');"

echo ""
echo "---"
echo ""

# Show git status
echo "📊 Git Status:"
git status --short || echo "(Not a git repo - that's ok for demo)"
echo ""

echo "🎉 Demo complete!"
echo ""
echo "Next steps:"
echo "1. Review the changes above"
echo "2. Run: /ai-dev . --task 'Add more functions'"
echo "3. Create PR when ready"
