#!/bin/bash
# Upload GitHub Actions workflow file via GitHub API

WORKSPACE_DIR="/home/huiquanyun/.openclaw/workspace"
GH_TOKEN="${GITHUB_TOKEN:-}"  # Use environment variable, exit if not set
if [ -z "$GH_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN environment variable is not set"
    exit 1
fi
REPO="hq-yun/Openclaw-AI-Code"
BRANCH="main"

cd "$WORKSPACE_DIR"

# Get current commit SHA
COMMIT_SHA=$(git rev-parse HEAD)

# Read workflow content
WORKFLOW_CONTENT=$(cat .github/workflows/auto-sync.yml | base64 -w 0)

# Prepare payload
PAYLOAD=$(cat <<EOF
{
  "message": "Add GitHub Actions auto-sync workflow",
  "committer": {
    "name": "hq-yun",
    "email": "hq-yun@users.noreply.github.com"
  },
  "tree": [
    {
      "path": ".github/workflows/auto-sync.yml",
      "mode": "100644",
      "type": "blob",
      "content": "$(cat .github/workflows/auto-sync.yml)"
    }
  ],
  "sha": "$COMMIT_SHA"
}
EOF
)

# Upload via GitHub API
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$REPO/git/trees/$COMMIT_SHA"
