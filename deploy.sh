#!/bin/bash

# Tetris Game Deployment Script
# Deploys the game to GitHub Pages (gh-pages branch)

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$SCRIPT_DIR/dist"
TEMP_GIT_DIR=""

echo "=========================================="
echo "    Tetris Game Deployment Script"
echo "=========================================="
echo ""

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed or not in PATH"
    exit 1
fi

# Check if we're in a git repository
if [ ! -d "$SCRIPT_DIR/.git" ]; then
    echo "Error: Not a git repository. Please run this script from the Tetris directory."
    exit 1
fi

# Create dist directory
echo "[1/5] Creating distribution directory..."
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

# Copy files to dist
echo "[2/5] Copying files to dist..."
cp -r "$SCRIPT_DIR"/* "$DIST_DIR/" 2>/dev/null || true
cp -r "$SCRIPT_DIR"/.* "$DIST_DIR/" 2>/dev/null || true

# Remove unnecessary files from dist
echo "[3/5] Cleaning up distribution files..."
rm -rf "$DIST_DIR/.git"
rm -f "$DIST_DIR/deploy.sh"

# Initialize git in dist folder for gh-pages deployment
echo "[4/5] Setting up deployment repository..."
cd "$DIST_DIR"
git init -b main --quiet
git config user.email "deploy@tetris.local"
git config user.name "Tetris Deploy"

# Add and commit files
git add .
git commit -m "Deploy to GitHub Pages [ci skip]" --quiet 2>/dev/null || git commit -m "Initial deployment" --quiet

# Handle gh-pages branch
if git rev-parse gh-pages --verify &> /dev/null; then
    # gh-pages branch exists, switch to it and update
    echo "[5/5] Updating gh-pages branch..."
    git checkout gh-pages --quiet 2>/dev/null || git checkout -b gh-pages --quiet

    # Remove old files except .git
    find . -type f ! -path './.git/*' -delete
    git add .
    git commit -m "Update deployment [ci skip]" --quiet 2>/dev/null || true

    # Go back to main branch, merge changes
    git checkout main --quiet 2>/dev/null || git checkout master --quiet
    git merge gh-pages --no-edit --quiet 2>/dev/null || true
    git checkout gh-pages --quiet
else
    echo "[5/5] Creating new gh-pages branch..."
    git checkout -b gh-pages --quiet
fi

# Push to remote
echo ""
echo "Pushing to remote repository..."
if git remote get-url origin &> /dev/null; then
    git push origin gh-pages --force --quiet 2>/dev/null

    if [ $? -eq 0 ]; then
        echo ""
        echo "=========================================="
        echo "  Deployment Successful!"
        echo "=========================================="
        echo ""
        echo "Your Tetris game has been deployed to GitHub Pages."
        echo ""

        # Try to get the repository URL and construct the page URL
        REPO_URL=$(git remote get-url origin 2>/dev/null || echo "")
        if [[ "$REPO_URL" =~ github.com[:/]([a-zA-Z0-9_-]+)/([a-zA-Z0-9_.-]+) ]]; then
            USERNAME="${BASH_REMATCH[1]}"
            REPO_NAME="${BASH_REMATCH[2]}"
            echo "URL: https://${USERNAME}.github.io/${REPO_NAME}/"
        fi
        echo ""
    else
        echo "Warning: Push failed. Make sure you have push access to the repository."
    fi
else
    echo "No remote 'origin' configured."
    echo "To enable GitHub Pages deployment:"
    echo "  1. Create a repository on GitHub"
    echo "  2. Run: git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
    echo "  3. Run this script again"
fi

# Cleanup
echo ""
echo "Deployment complete!"
