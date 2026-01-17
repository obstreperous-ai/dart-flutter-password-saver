#!/bin/bash
# Git pre-commit hook for Dart/Flutter code quality checks
# This hook runs automatically before each commit

set -e

echo "Running pre-commit checks..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if Flutter/Dart is available
if ! command -v dart &> /dev/null; then
    print_error "dart command not found. Please ensure Flutter/Dart is installed and in PATH"
    exit 1
fi

# Get list of staged Dart files
STAGED_DART_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.dart$' || true)

if [ -z "$STAGED_DART_FILES" ]; then
    print_status "No Dart files to check"
    exit 0
fi

echo "Checking $(echo "$STAGED_DART_FILES" | wc -l) Dart file(s)..."

# Run dart format check
echo ""
echo "Running dart format check..."
if dart format --set-exit-if-changed $STAGED_DART_FILES; then
    print_status "Code formatting passed"
else
    print_error "Code formatting failed"
    echo ""
    echo "Please run: dart format ."
    echo "Or let the hook fix it by running: dart format --fix ."
    exit 1
fi

# Run dart analyze
echo ""
echo "Running dart analyze..."
if dart analyze --fatal-infos; then
    print_status "Code analysis passed"
else
    print_error "Code analysis failed"
    echo ""
    echo "Please fix the issues reported above"
    exit 1
fi

echo ""
print_status "All pre-commit checks passed!"
exit 0
