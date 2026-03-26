#!/bin/bash
# AI Dev CLI - Simple interface for /ai-dev command
# Usage: ai-dev [project_path] --task "requirement"

PROJECT_PATH="${1:-.}"
TASK=""
TEST_CMD=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --task) TASK="$2"; shift 2 ;;
        --test) TEST_CMD="$2"; shift 2 ;;
        *) PROJECT_PATH="$1"; shift ;;
    esac
done

if [ -z "$TASK" ]; then
    echo "❌ Error: --task is required"
    exit 1
fi

# Create temporary task file
TIMESTAMP=$(date +%Y%m%d%H%M%S)
TASK_FILE="/tmp/ai-dev-task-${TIMESTAMP}.json"

cat > "$TASK_FILE" <<EOF
{
  "project_path": "$(realpath $PROJECT_PATH)",
  "task": "$TASK",
  "test_cmd": "${TEST_CMD}",
  "timestamp": "$TIMESTAMP"
}
EOF

# Spawn AI Dev agent via OpenClaw
openclaw sessions spawn \
  --label "ai-dev-${TIMESTAMP}" \
  --runtime acp \
  --agent-id claude-code \
  --task "Complete this development task: $(cat $TASK_FILE)" \
  --cwd "$(dirname $TASK_FILE)" \
  --mode session

# Cleanup on exit
trap "rm -f $TASK_FILE" EXIT

echo "🚀 AI Dev agent spawned for task: $TASK"
echo "Agent will execute in background..."
