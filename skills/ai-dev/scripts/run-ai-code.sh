#!/bin/bash
# Run AI Code Agent for specific task
# This is called by the main ai-dev script

TASK_FILE="$1"
if [ -z "$TASK_FILE" ]; then
    echo "Usage: run-ai-code <task_file>"
    exit 1
fi

# Load task from file
PROJECT_PATH=$(grep "project_path:" "$TASK_FILE" | cut -d'"' -f4)
TASK=$(grep "task:" "$TASK_FILE" | cut -d'"' -f2-)

echo "🤖 AI Code Agent: $TASK"
echo "Project: $PROJECT_PATH"

# Spawn Claude Code via sessions_spawn
cd /home/huiquanyun/.openclaw/workspace

openclaw sessions spawn \
  --task "$TASK" \
  --runtime acp \
  --agent-id claude-code \
  --cwd "$PROJECT_PATH" \
  --mode run \
  --timeout-seconds 300
