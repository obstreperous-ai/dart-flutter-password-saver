#!/bin/bash
# Script to run all code quality checks locally
# Run this before committing or creating a PR

set -e

echo "================================"
echo "Code Quality Checks"
echo "================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track overall status
CHECKS_PASSED=0
CHECKS_FAILED=0

print_header() {
    echo -e "${BLUE}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    CHECKS_FAILED=$((CHECKS_FAILED + 1))
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if Flutter/Dart is available
if ! command -v flutter &> /dev/null; then
    print_error "flutter command not found. Please ensure Flutter/Dart is installed and in PATH"
    exit 1
fi

print_success "Flutter/Dart found in PATH"
echo ""

# Check 1: Dependencies
print_header "Checking dependencies..."
if flutter pub get > /dev/null 2>&1; then
    print_success "Dependencies installed"
else
    print_error "Failed to install dependencies"
    exit 1
fi
echo ""

# Check 2: Code Formatting
print_header "Checking code formatting..."
if dart format --set-exit-if-changed . > /dev/null 2>&1; then
    print_success "Code formatting passed"
else
    print_error "Code formatting failed"
    echo ""
    echo "Fix with: dart format ."
    echo ""
fi
echo ""

# Check 3: Static Analysis
print_header "Running static analysis..."
if dart analyze --fatal-infos 2>&1 | tee /tmp/analyze-output.txt; then
    if ! grep -q "issue found" /tmp/analyze-output.txt && ! grep -q "issues found" /tmp/analyze-output.txt; then
        print_success "Static analysis passed"
    else
        print_error "Static analysis found issues"
    fi
else
    print_error "Static analysis failed"
fi
rm -f /tmp/analyze-output.txt
echo ""

# Check 4: Dependency Audit
print_header "Checking for outdated dependencies..."
flutter pub outdated --no-dev-dependencies --no-dependency-overrides > /dev/null 2>&1 || true
print_success "Dependency check completed"
echo ""

# Check 5: Security Checks
print_header "Running security checks..."
SECURITY_ISSUES=0

# Check for print statements
if grep -r "print(" lib/ --include="*.dart" | grep -v "// ignore" | grep -v "test" > /dev/null 2>&1; then
    print_warning "Found print() statements in code (consider using proper logging)"
    SECURITY_ISSUES=$((SECURITY_ISSUES + 1))
fi

# Check for hardcoded credentials patterns (simple check)
if grep -rE "(password|secret|key)\s*=\s*['\"]" lib/ --include="*.dart" | grep -v "// ignore" > /dev/null 2>&1; then
    print_warning "Found potential hardcoded credentials (review manually)"
    SECURITY_ISSUES=$((SECURITY_ISSUES + 1))
fi

if [ $SECURITY_ISSUES -eq 0 ]; then
    print_success "No obvious security issues found"
fi
echo ""

# Summary
echo "================================"
echo "Summary"
echo "================================"
echo ""

if [ $CHECKS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All critical checks passed!${NC}"
    echo ""
    echo "You're ready to:"
    echo "  - Commit your changes"
    echo "  - Create a pull request"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Some checks failed${NC}"
    echo ""
    echo "Please fix the issues above before committing."
    echo ""
    exit 1
fi
