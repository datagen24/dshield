#!/bin/bash

# DShield Security Ecosystem Meta Project Setup Verification
# This script verifies that the meta project is properly configured

set -e

echo "🔍 Verifying DShield Security Ecosystem Meta Project Setup..."
echo "=========================================================="

# Check git configuration
echo "📋 Git Configuration:"
echo "  User: $(git config --global user.name)"
echo "  Email: $(git config --global user.email)"
echo "  Default Branch: $(git config --global init.defaultBranch)"
echo ""

# Check GitHub CLI authentication
echo "🔐 GitHub CLI Authentication:"
if gh auth status >/dev/null 2>&1; then
    echo "  ✅ GitHub CLI is authenticated"
    gh auth status --json user | jq -r '.user.login' | xargs echo "  User:"
else
    echo "  ❌ GitHub CLI is not authenticated"
    exit 1
fi
echo ""

# Check remote repository
echo "🌐 Remote Repository:"
if git remote get-url origin >/dev/null 2>&1; then
    echo "  ✅ Origin remote is configured"
    echo "  URL: $(git remote get-url origin)"
else
    echo "  ❌ Origin remote is not configured"
    exit 1
fi
echo ""

# Check submodules
echo "📦 Git Submodules:"
if [ -f .gitmodules ]; then
    echo "  ✅ .gitmodules file exists"
    echo "  Submodules:"
    git submodule foreach 'echo "    - $name: $(git describe --tags --always 2>/dev/null || echo "no tags")"'
else
    echo "  ❌ .gitmodules file not found"
    exit 1
fi
echo ""

# Check project structure
echo "📁 Project Structure:"
for project in dshield-mcp DShield-SIEM dshield-misp; do
    if [ -d "$project" ]; then
        echo "  ✅ $project directory exists"
        if [ -d "$project/.git" ]; then
            echo "    - Git repository: ✅"
        else
            echo "    - Git repository: ❌"
        fi
        if [ -d "$project/.cursor" ]; then
            echo "    - Cursor rules: ✅"
        else
            echo "    - Cursor rules: ❌ (optional)"
        fi
    else
        echo "  ❌ $project directory not found"
    fi
done
echo ""

# Check meta project files
echo "📄 Meta Project Files:"
for file in README.md .gitmodules .gitignore; do
    if [ -f "$file" ]; then
        echo "  ✅ $file exists"
    else
        echo "  ❌ $file not found"
    fi
done

for dir in .cursor docs scripts; do
    if [ -d "$dir" ]; then
        echo "  ✅ $dir directory exists"
    else
        echo "  ❌ $dir directory not found"
    fi
done
echo ""

# Check git status
echo "📊 Git Status:"
if git status --porcelain | grep -q .; then
    echo "  ⚠️  There are uncommitted changes:"
    git status --porcelain | sed 's/^/    /'
else
    echo "  ✅ Working directory is clean"
fi
echo ""

# Check branch status
echo "🌿 Branch Status:"
current_branch=$(git branch --show-current)
echo "  Current branch: $current_branch"
if git rev-parse --verify origin/$current_branch >/dev/null 2>&1; then
    if git rev-list HEAD...origin/$current_branch --count | grep -q "0"; then
        echo "  ✅ Branch is up to date with origin"
    else
        echo "  ⚠️  Branch is behind origin"
    fi
else
    echo "  ⚠️  No tracking branch configured"
fi
echo ""

echo "🎉 Setup verification complete!"
echo ""
echo "Next steps:"
echo "1. Visit: https://github.com/datagen24/dshield"
echo "2. Review the repository structure and documentation"
echo "3. Start working on individual projects or integration features"
echo ""
echo "For development:"
echo "- Individual projects: cd dshield-mcp/ (or other project directories)"
echo "- Integration work: Stay in the meta project root"
echo "- Use 'git submodule update --remote' to update submodules" 