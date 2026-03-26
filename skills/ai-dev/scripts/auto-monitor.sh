#!/bin/bash
# Auto-monitor workspace and trigger AI Dev when needed

PROJECT_PATH="/home/huiquanyun/桌面/Openclaw-AI-Code"
WORKSPACE="/home/huiquanyun/.openclaw/workspace"
LOG_FILE="$WORKSPACE/logs/ai-dev-monitor.log"

mkdir -p "$WORKSPACE/logs"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_workspace_changes() {
    cd "$PROJECT_PATH"
    
    # Check for uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
        log "📝 Found uncommitted changes in workspace"
        
        # Count modified files
        MODIFIED_FILES=$(git status --porcelain | wc -l)
        log "   Modified: $MODIFIED_FILES file(s)"
        
        return 0
    fi
    
    return 1
}

check_git_status() {
    cd "$PROJECT_PATH"
    
    # Check if behind origin
    BEHIND=$(git rev-list --count HEAD...origin/main 2>/dev/null || echo "0")
    
    if [ "$BEHIND" -gt 0 ]; then
        log "📤 Behind origin by $BEHIND commit(s)"
        
        # Auto-push if safe to do so
        git push origin main 2>&1 && log "✅ Auto-pushed $BEHIND commit(s)" || log "❌ Push failed"
    fi
    
    # Check for unpushed local commits
    UNPUSHED=$(git rev-list --count HEAD...origin/main 2>/dev/null || echo "0")
    
    if [ "$UNPUSHED" -gt 0 ]; then
        log "📤 $UNPUSHED unpushed commit(s)"
        return 0
    fi
    
    return 1
}

check_for_ai_tasks() {
    cd "$PROJECT_PATH"
    
    # Look for AI task files (created by previous sessions)
    TASK_FILES=$(find . -name ".ai-dev-task-*.md" 2>/dev/null | head -1)
    
    if [ -n "$TASK_FILES" ]; then
        log "🤖 Found pending AI task: $TASK_FILES"
        
        # Extract task description
        TASK_DESC=$(grep "^# " "$TASK_FILES" | sed 's/^# //')
        log "   Task: $TASK_DESC"
        
        return 0
    fi
    
    return 1
}

run_ai_dev_check() {
    cd "$PROJECT_PATH"
    
    # Check if there are any changes to process
    if check_workspace_changes || check_git_status; then
        log "🔄 Running AI Dev workflow..."
        
        # Create a temporary task file for the agent
        TIMESTAMP=$(date +%Y%m%d%H%M%S)
        TASK_FILE="$WORKSPACE/logs/ai-task-${TIMESTAMP}.json"
        
        cat > "$TASK_FILE" <<EOF
{
  "project_path": "$(realpath .)",
  "task": "Auto-synchronize workspace changes to GitHub",
  "test_cmd": "npm test",
  "timestamp": "$TIMESTAMP",
  "auto_mode": true
}
EOF
        
        log "📝 Task file created: $TASK_FILE"
        
        # Trigger OpenClaw session (simulated for now)
        log "⚙️  AI Dev workflow triggered via cron"
        
        # Cleanup after processing
        sleep 5  # Simulate processing time
        rm -f "$TASK_FILE"
        
        return 0
    fi
    
    return 1
}

# Main loop
log "🚀 AI Dev Monitor started"
log "Monitoring: $PROJECT_PATH"
log ""

while true; do
    run_ai_dev_check || true
    
    # Wait 5 minutes before next check
    sleep 300
done
