#!/bin/bash
# Script to set up git hooks for code quality checks
# This script installs pre-commit hooks that will run before each commit

set -e

echo "Setting up pre-commit hooks for code quality..."

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "Error: This script must be run from the root of the git repository"
    exit 1
fi

# Check if pre-commit is installed
if ! command -v pre-commit &> /dev/null; then
    echo "pre-commit is not installed. Installing with pip..."
    
    # Try to install with pip
    if command -v pip3 &> /dev/null; then
        pip3 install pre-commit
    elif command -v pip &> /dev/null; then
        pip install pre-commit
    else
        echo "Error: pip is not installed. Please install pip first."
        echo "Visit: https://pip.pypa.io/en/stable/installation/"
        exit 1
    fi
fi

# Install the pre-commit hooks
echo "Installing pre-commit hooks..."
pre-commit install

# Run hooks on all files to ensure everything passes
echo "Running hooks on all files to verify setup..."
pre-commit run --all-files || {
    echo ""
    echo "Some hooks failed. Please fix the issues and try again."
    echo "You can run 'pre-commit run --all-files' to check again."
    exit 1
}

echo ""
echo "✓ Pre-commit hooks installed successfully!"
echo ""
echo "The following checks will now run automatically before each commit:"
echo "  - Trailing whitespace removal"
echo "  - End of file fixing"
echo "  - YAML/JSON validation"
echo "  - Large file detection"
echo "  - Merge conflict detection"
echo "  - Private key detection"
echo "  - Dart formatting (dart format)"
echo "  - Dart analysis (dart analyze)"
echo "  - Flutter dependency check"
echo ""
echo "To skip hooks temporarily (not recommended), use: git commit --no-verify"
echo ""
