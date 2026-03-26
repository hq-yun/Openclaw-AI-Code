#!/bin/bash
# Run Claude Code agent for AI Dev workflow
# This is the REAL implementation (not demo)

PROJECT_PATH="${1:-.}"
TASK_DESCRIPTION="${2:-}"
TEST_CMD="${3:-}"

if [ -z "$TASK_DESCRIPTION" ]; then
    echo "❌ Error: Task description required"
    exit 1
fi

echo "🤖 Starting REAL Claude Code Agent..."
echo "Project: $PROJECT_PATH"
echo "Task: $TASK_DESCRIPTION"
echo ""

# Create task context file
CONTEXT_FILE="/tmp/ai-dev-context-$(date +%s).json"

cat > "$CONTEXT_FILE" <<EOF
{
  "project_path": "$(realpath $PROJECT_PATH)",
  "task_description": "$TASK_DESCRIPTION",
  "test_command": "$TEST_CMD",
  "timestamp": "$(date -Iseconds)"
}
EOF

# Spawn Claude Code agent via OpenClaw sessions_spawn
echo "📝 Spawning Claude Code session..."
echo ""

# Use OpenClaw's sessions_spawn with runtime="acp" for ACP harness
# This will invoke the actual Claude Code model

openclaw sessions spawn \
  --label "ai-dev-claude-$(date +%s)" \
  --runtime acp \
  --agent-id claude-code \
  --cwd "$PROJECT_PATH" \
  --mode session \
  --task "Complete this development task:

**Project Path**: $(realpath $PROJECT_PATH)
**Task Description**: $TASK_DESCRIPTION

**Context File**: $CONTEXT_FILE

Instructions:
1. Analyze the codebase structure
2. Implement the required changes following best practices
3. Write tests if needed (use existing test framework)
4. Create detailed commit message
5. Report back with:
   - Files modified/created/deleted
   - Test results (if any)
   - Summary of implementation

**Important**: 
- Work within the project directory only
- Follow existing code style and patterns
- Add comments where necessary
- Ensure tests pass before completing" \
  --timeout-seconds 600 \
  --cleanup keep

# Cleanup context file
rm -f "$CONTEXT_FILE"

echo ""
echo "📊 Claude Code session spawned!"
echo "Monitor the session for execution results."
echo "Session will complete and return implementation report."
