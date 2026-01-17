#!/bin/bash
# Script to install git pre-commit hook for code quality checks
# This provides an alternative to the pre-commit framework

set -e

echo "Installing git pre-commit hook..."

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "Error: This script must be run from the root of the git repository"
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Copy the pre-commit hook
cp scripts/pre-commit-hook.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo ""
echo "✓ Pre-commit hook installed successfully!"
echo ""
echo "The following checks will now run automatically before each commit:"
echo "  - Dart formatting (dart format)"
echo "  - Dart analysis (dart analyze)"
echo ""
echo "To skip hooks temporarily (not recommended), use: git commit --no-verify"
echo ""
