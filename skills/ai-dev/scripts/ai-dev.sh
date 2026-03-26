#!/bin/bash
# AI Code Development Workflow - Main Script
# Usage: /ai-dev [project_path] --task "your requirement"

set -e

PROJECT_PATH="${1:-.}"
TASK=""
TEST_CMD=""
REVIEWERS=""
AUTO_MERGE="true"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --task)
            TASK="$2"
            shift 2
            ;;
        --test)
            TEST_CMD="$2"
            shift 2
            ;;
        --reviewer)
            REVIEWERS="$2"
            shift 2
            ;;
        --no-merge)
            AUTO_MERGE="false"
            shift
            ;;
        *)
            if [ -z "$PROJECT_PATH" ] || [ "$1" = "." ]; then
                PROJECT_PATH="$1"
                shift
            else
                echo "Unknown argument: $1"
                exit 1
            fi
            ;;
    esac
done

if [ -z "$TASK" ]; then
    echo "❌ Error: --task is required"
    echo "Usage: /ai-dev [project_path] --task 'your requirement'"
    exit 1
fi

# Configuration
WORKSPACE="/home/huiquanyun/.openclaw/workspace"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BRANCH_NAME="feature/ai-dev-${TIMESTAMP}"
REPO_URL=$(git -C "$PROJECT_PATH" remote get-url origin 2>/dev/null || echo "")

echo "🚀 AI Code Development Workflow"
echo "================================"
echo "Task: $TASK"
echo "Project: $PROJECT_PATH"
echo "Branch: $BRANCH_NAME"
echo ""

# Step 1: Setup environment
cd "$PROJECT_PATH"

# Check if forked or original repo
if git remote get-url upstream >/dev/null 2>&1; then
    echo "✅ Fork detected, using upstream as base"
    BASE_REPO=$(git remote get-url upstream)
else
    echo "⚠️  No fork found, will create PR to origin"
    BASE_REPO="$REPO_URL"
fi

# Step 2: Create feature branch
echo "📦 Creating feature branch..."
git checkout -b "$BRANCH_NAME"

# Step 3: Execute AI Code Task via REAL Claude Code Agent
echo "🤖 Starting REAL Claude Code execution..."
cd "$WORKSPACE"

# Spawn Claude Code agent for this task using OpenClaw sessions_spawn
echo "📝 Spawning Claude Code agent..."

openclaw sessions spawn \
  --label "ai-dev-claude-${TIMESTAMP}" \
  --runtime acp \
  --agent-id claude-code \
  --cwd "$PROJECT_PATH" \
  --mode session \
  --task "Complete this development task:

**Project Path**: $PROJECT_PATH
**Task Description**: $TASK

Instructions:
1. Analyze the codebase structure
2. Implement the required changes following best practices
3. Write tests if needed (use existing test framework)
4. Create detailed commit message with files modified
5. Report back with implementation summary

**Important**: Work within the project directory only, follow existing patterns." \
  --timeout-seconds 600 \
  --cleanup keep
import subprocess
import json
import sys
import os

# Load task config
with open('/tmp/ai-dev-task.json', 'r') as f:
    config = json.load(f)

project_path = config['project_path']
task = config['task']
test_cmd = config.get('test_cmd', '')
timestamp = config['timestamp']
branch_name = config['branch_name']

print(f"\n🎯 AI Dev Agent Started")
print(f"Task: {task}")
print(f"Project: {project_path}")
print(f"Branch: {branch_name}\n")

# Step 1: Copy task file to project
task_file = f"{project_path}/.ai-dev-task-{timestamp}.md"
with open(task_file, 'w') as f:
    f.write(f"# AI Development Task\n\n{task}\n\n---\nGenerated at {timestamp}")

print("✅ Task file created")

# Step 2: Execute Claude Code agent via sessions_spawn
print("\n🚀 Spawning Claude Code agent...")
agent_task = f"""
You are an expert developer. Complete this task in the project:

**Project Path**: {project_path}
**Task Description**: {task}

Instructions:
1. Analyze the codebase structure
2. Implement the required changes
3. Follow existing code style and patterns
4. Add tests if needed
5. Create a detailed commit message

Report back with:
- Files modified
- Test results
- Summary of changes
"""

# Use OpenClaw sessions_spawn to run Claude Code
result = subprocess.run([
    'openclaw', 'sessions', 'spawn',
    '--task', agent_task,
    '--runtime', 'acp',
    '--agent-id', 'claude-code',  # or codex
    '--cwd', project_path,
    '--mode', 'run'
], capture_output=True, text=True)

print(result.stdout)
if result.stderr:
    print(f"Agent output:\n{result.stderr}")

# Step 3: Run tests if test command provided
if test_cmd:
    print(f"\n🧪 Running tests: {test_cmd}")
    os.chdir(project_path)
    test_result = subprocess.run(test_cmd, shell=True, capture_output=True, text=True)
    
    if test_result.returncode == 0:
        print("✅ Tests passed!")
    else:
        print(f"❌ Tests failed:\n{test_result.stdout}\n{test_result.stderr}")
        
        # Auto-fix attempt (simple retry logic)
        print("\n🔧 Attempting auto-fix...")
        fix_task = f"""
The tests failed. Please analyze the errors and fix them:

**Test Output**: {test_result.stdout[:500]}{test_result.stderr[:500]}

Fix the issues and re-run tests.
"""
        
        # Retry with Claude Code (simplified for demo)
        print("Note: Auto-fix would invoke Claude Code here")
else:
    print("\n⚠️  No test command specified, skipping automated testing")

# Step 4: Commit changes
print("\n📝 Creating commit...")
os.chdir(project_path)
subprocess.run(['git', 'add', '.'], check=True)
subprocess.run([
    'git', 'commit', '-m', 
    f"AI Dev: {task[:50]}{'...' if len(task) > 50 else ''}"
], check=True, capture_output=True)

print("✅ Changes committed")

# Step 5: Push to branch
print("\n🚀 Pushing changes...")
try:
    subprocess.run([
        'git', 'push', '-u', 'origin', branch_name
    ], check=True, capture_output=True)
    print(f"✅ Pushed to {branch_name}")
except subprocess.CalledProcessError as e:
    print(f"⚠️  Push failed (might already exist): {e}")

# Step 6: Create PR
print("\n🔀 Creating Pull Request...")
pr_title = f"AI Dev: {task[:50]}{'...' if len(task) > 50 else ''}"
pr_body = f"""
Automated PR from OpenClaw AI Dev workflow.

**Task**: {task}
**Branch**: {branch_name}
**Generated**: {timestamp}

## Changes
- Implementation of requested feature/fix

## Testing
- [ ] Manual testing completed
- [ ] Tests passing (check CI)

---
*This PR was automatically generated by OpenClaw AI Dev*
"""

# Use gh CLI to create PR
try:
    pr_result = subprocess.run([
        'gh', 'pr', 'create',
        '--title', pr_title,
        '--body', pr_body.replace('\n', '\\n'),
        '--head', branch_name,
        '--base', 'main'  # or detect from repo
    ], capture_output=True, text=True)
    
    if pr_result.returncode == 0:
        print("✅ PR created successfully!")
        # Extract PR number from output
        for line in pr_result.stdout.split('\n'):
            if 'number' in line.lower() or '#' in line:
                print(f"🔗 {line.strip()}")
    else:
        print(f"⚠️  gh CLI not configured or PR creation failed:\n{pr_result.stderr}")
except FileNotFoundError:
    print("⚠️  GitHub CLI (gh) not installed. Manual PR creation needed.")
    print(f"""
Please create PR manually:
- From: {branch_name}
- To: main
- Title: {pr_title}
- Body:
{pr_body}
""")

print("\n" + "="*50)
print("✅ AI Dev Workflow Completed!")
print("="*50)
PYTHON_SCRIPT

# Step 7: Generate report
echo ""
echo "📊 AI Dev Report"
echo "================="
echo "**Task**: $TASK"
echo "**Time**: $(date '+%Y-%m-%d %H:%M GMT+8')"
echo "**Branch**: $BRANCH_NAME"
echo ""

# Cleanup temp files
rm -f /tmp/ai-dev-task.json
find "$PROJECT_PATH" -name ".ai-dev-task-*.md" -delete 2>/dev/null || true

echo "🎉 Done! Check your branch and PR for review."
