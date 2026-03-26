#!/usr/bin/env python3
import requests
import base64
import os
import sys

# Configuration - Get token from environment variable
GH_TOKEN = os.environ.get("GITHUB_TOKEN")
if not GH_TOKEN:
    print("Error: GITHUB_TOKEN environment variable is not set", file=sys.stderr)
    sys.exit(1)

REPO = "hq-yun/Openclaw-AI-Code"
BRANCH = "main"
WORKFLOW_FILE = "/home/huiquanyun/.openclaw/workspace/.github/workflows/auto-sync.yml"

# Get current commit SHA and tree
response = requests.get(
    f"https://api.github.com/repos/{REPO}/contents/.github/workflows?ref={BRANCH}",
    headers={"Authorization": f"token {GH_TOKEN}"}
)

if response.status_code == 200:
    files = response.json()
    print(f"Found {len(files)} existing workflow files")
    
    # Create new commit with update/add
    content_response = requests.put(
        f"https://api.github.com/repos/{REPO}/contents/.github/workflows/auto-sync.yml",
        headers={"Authorization": f"token {GH_TOKEN}"},
        json={
            "message": "Add GitHub Actions auto-sync workflow",
            "content": base64.b64encode(open(WORKFLOW_FILE, 'rb').read()).decode('utf-8'),
            "branch": BRANCH
        }
    )
    
    if content_response.status_code in [200, 201]:
        data = content_response.json()
        print("✅ Successfully uploaded workflow!")
        print(f"🔗 View commit: {data.get('commit', {}).get('html_url', 'N/A')}")
    else:
        print(f"❌ Failed: {content_response.status_code} - {content_response.text}")
else:
    print(f"Error getting files: {response.status_code} - {response.text}")
