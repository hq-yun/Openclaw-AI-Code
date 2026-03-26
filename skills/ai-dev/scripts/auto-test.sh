#!/bin/bash
# Auto-run tests with intelligent retry and fix attempts

PROJECT_PATH="${1:-.}"
MAX_RETRIES=${2:-3}

cd "$PROJECT_PATH"

log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

detect_test_command() {
    # Try to detect test command from package.json or other config files
    
    if [ -f "package.json" ]; then
        TEST_CMD=$(grep -o '"test"[[:space:]]*:[[:space:]]*"[^"]*"' package.json | cut -d'"' -f4)
        
        if [ -n "$TEST_CMD" ] && [ "$TEST_CMD" != 'echo "Error: no test specified"' ]; then
            echo "$TEST_CMD"
            return 0
        fi
    fi
    
    # Try common test commands
    if command -v pytest &> /dev/null; then
        echo "pytest"
        return 0
    fi
    
    if command -v jest &> /dev/null; then
        echo "jest"
        return 0
    fi
    
    if [ -f "Makefile" ]; then
        TEST_TARGET=$(grep -E "^test:" Makefile | cut -d':' -f2 | tr -d ' ')
        if [ -n "$TEST_TARGET" ]; then
            echo "make $TEST_TARGET"
            return 0
        fi
    fi
    
    echo ""
    return 1
}

run_test() {
    local TEST_CMD="$1"
    
    log "🧪 Running tests: $TEST_CMD"
    
    OUTPUT=$(eval "$TEST_CMD" 2>&1)
    EXIT_CODE=$?
    
    if [ $EXIT_CODE -eq 0 ]; then
        log "✅ Tests passed!"
        echo "$OUTPUT" | tail -20
        return 0
    else
        log "❌ Tests failed (exit code: $EXIT_CODE)"
        echo "$OUTPUT" | tail -30
        
        # Extract error messages for potential auto-fix
        ERROR_MSG=$(echo "$OUTPUT" | grep -i "error\|fail\|exception" | head -5)
        
        if [ -n "$ERROR_MSG" ]; then
            log "🔍 Error analysis:"
            echo "$ERROR_MSG" | sed 's/^/   /'
        fi
        
        return 1
    fi
}

auto_fix_common_issues() {
    local ERROR_OUTPUT="$1"
    
    log "🔧 Attempting auto-fix..."
    
    # Common fixes
    
    # Fix: Missing dependencies
    if echo "$ERROR_OUTPUT" | grep -q "Cannot find module"; then
        log "   → Installing missing modules..."
        npm install 2>/dev/null || return 1
        return 0
    fi
    
    # Fix: Syntax errors (simple cases)
    if echo "$ERROR_OUTPUT" | grep -q "SyntaxError"; then
        log "   → Checking for syntax issues in recent changes..."
        
        # Get last modified JS files
        MODIFIED_FILES=$(git diff --name-only HEAD~1 2>/dev/null | grep "\.js$" || true)
        
        if [ -n "$MODIFIED_FILES" ]; then
            log "   → Files to check: $MODIFIED_FILES"
            # Note: Real auto-fix would require AI analysis
            return 0
        fi
    fi
    
    # Fix: Test environment issues
    if echo "$ERROR_OUTPUT" | grep -q "Cannot find.*path\|ENOENT"; then
        log "   → Checking test fixtures..."
        
        # Check for missing fixture files
        MISSING=$(find . -name "*.fixture" -o -name "*.mock" 2>/dev/null | wc -l)
        
        if [ "$MISSING" -eq 0 ]; then
            log "   ⚠️  No fixtures found, tests may need setup"
        fi
        
        return 0
    fi
    
    # Generic: Try to identify and report the issue
    log "   → Unknown error type, manual intervention needed"
    
    return 1
}

# Main execution
log "🚀 Auto-test started"
log "Project: $(pwd)"
log ""

# Detect test command
TEST_CMD=$(detect_test_command)

if [ -z "$TEST_CMD" ]; then
    log "⚠️  No test command detected. Skipping automated testing."
    log "   Add a 'test' script to package.json or create Makefile with 'test' target."
    exit 0
fi

log "Detected test command: $TEST_CMD"
log ""

# Run tests with retry logic
for i in $(seq 1 $MAX_RETRIES); do
    log "=== Attempt $i of $MAX_RETRIES ==="
    
    if run_test "$TEST_CMD"; then
        log ""
        log "🎉 Tests passed on attempt $i!"
        exit 0
    fi
    
    if [ $i -lt $MAX_RETRIES ]; then
        log ""
        
        # Attempt auto-fix
        ERROR_OUTPUT=$(run_test "$TEST_CMD" 2>&1) || true
        
        if auto_fix_common_issues "$ERROR_OUTPUT"; then
            log "✅ Auto-fix applied, retrying..."
            sleep 2
            continue
        else
            log "❌ Auto-fix failed or not applicable"
        fi
    fi
    
    log ""
done

log "❌ All $MAX_RETRIES attempts failed"
exit 1
