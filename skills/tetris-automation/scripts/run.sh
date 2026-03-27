#!/bin/bash
# Tetris Automation Skill Entry Point
# Usage: /tetris-automation [modification description]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/tetris-automation.sh" "$@"
