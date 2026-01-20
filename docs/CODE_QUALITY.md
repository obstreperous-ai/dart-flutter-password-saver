# Code Quality Tools Documentation

This document explains the code quality tools and processes integrated into this project.

## Overview

The Password Saver project maintains high code quality standards through:

1. **Static Analysis**: Comprehensive linter rules that catch bugs and enforce style
2. **Code Formatting**: Automated formatting with `dart format`
3. **Pre-commit Hooks**: Automatic checks before each commit
4. **CI/CD Integration**: Automated checks on all PRs and pushes
5. **Dependency Security**: Regular scanning for vulnerable dependencies

## Analysis Rules

The project uses a comprehensive set of linter rules defined in `analysis_options.yaml`:

### Error Prevention Rules
- Catch potential bugs (e.g., `unrelated_type_equality_checks`, `test_types_in_equals`)
- Prevent resource leaks (e.g., `close_sinks`, `cancel_subscriptions`)
- Enforce null safety (e.g., `always_require_non_null_named_parameters`)

### Style Consistency Rules
- Enforce naming conventions (e.g., `camel_case_types`, `file_names`)
- Require trailing commas for better diffs (e.g., `require_trailing_commas`)
- Prefer const constructors (e.g., `prefer_const_constructors`)
- Use single quotes for strings (e.g., `prefer_single_quotes`)

### Performance Rules
- Encourage efficient code (e.g., `prefer_collection_literals`)
- Avoid slow operations (e.g., `avoid_slow_async_io`)

### Security Rules
- Prevent common vulnerabilities
- Strict type checking with `strict-casts`, `strict-inference`, `strict-raw-types`

## Pre-commit Hooks

We provide two approaches for pre-commit hooks:

### Approach 1: Simple Git Hooks (Recommended)

```bash
./scripts/install-git-hooks.sh
```

This installs a simple bash-based pre-commit hook that:
- Checks code formatting with `dart format`
- Runs static analysis with `dart analyze`
- Provides clear error messages

**Pros:**
- No dependencies (uses bash and dart/flutter only)
- Simple and fast
- Easy to understand and modify

**Cons:**
- Less flexible than pre-commit framework
- Fewer built-in checks

### Approach 2: Pre-commit Framework

```bash
./setup-hooks.sh
```

This uses the [pre-commit](https://pre-commit.com/) framework, which provides:
- Multiple built-in hooks (trailing whitespace, large files, etc.)
- Dependency checking
- More extensive validation

**Pros:**
- More comprehensive checks
- Industry-standard tool
- Highly configurable

**Cons:**
- Requires Python and pip
- Slightly slower
- More complex setup

## Quality Check Scripts

### Full Quality Check

```bash
./scripts/check-quality.sh
```

Runs all quality checks in sequence:
1. ✅ Dependency installation
2. ✅ Code formatting
3. ✅ Static analysis
4. ✅ Dependency audit
5. ✅ Security checks

Use this before committing or creating a PR.

### Individual Checks

**Format code:**
```bash
dart format .
```

**Analyze code:**
```bash
dart analyze --fatal-infos
```

**Check dependencies:**
```bash
flutter pub outdated
```

## CI/CD Workflows

### Code Quality Workflow

**File:** `.github/workflows/code-quality.yml`

**Triggers:**
- Push to main/master/develop branches
- Pull requests to main/master/develop branches

**Checks:**
- Code formatting verification
- Static analysis with fatal infos
- Common issue detection (print statements, TODOs)

### Build and Test Workflow

**File:** `.github/workflows/build-test.yml`

**Triggers:**
- Push to main/master/develop branches
- Pull requests to main/master/develop branches

**Checks:**
- Builds for Linux and macOS
- Runs tests
- Verifies cross-platform compatibility

### Dependency Scan Workflow

**File:** `.github/workflows/dependency-scan.yml`

**Triggers:**
- Push to main/master/develop branches
- Pull requests to main/master/develop branches
- Weekly schedule (Monday at 00:00 UTC)

**Checks:**
- Outdated dependencies
- Security advisories
- Version constraint analysis

## Best Practices

### Before Committing

1. **Run quality checks:**
   ```bash
   ./scripts/check-quality.sh
   ```

2. **Fix any issues:**
   - Format: `dart format .`
   - Analyze: `dart analyze --fatal-infos`

3. **Test your changes:**
   ```bash
   flutter run -d linux  # or macos
   ```

4. **Commit with meaningful messages:**
   ```bash
   git add .
   git commit -m "feat: add feature description"
   ```

### Before Creating a PR

1. ✅ All quality checks pass locally
2. ✅ Code is properly formatted
3. ✅ No analysis warnings or errors
4. ✅ Application builds successfully
5. ✅ Changes have been tested manually
6. ✅ Dependencies are up to date and secure

### Code Review Checklist

When reviewing PRs, verify:

- [ ] All CI checks pass
- [ ] Code follows project style guidelines
- [ ] No security vulnerabilities introduced
- [ ] Changes are minimal and focused
- [ ] Documentation is updated if needed
- [ ] No unnecessary dependencies added

## Troubleshooting

### Pre-commit Hook Fails

**Issue:** Hook fails with "dart command not found"

**Solution:** Ensure Flutter/Dart is in your PATH:
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

**Issue:** Hook fails on formatting

**Solution:** Run `dart format .` to auto-fix formatting issues

### Static Analysis Errors

**Issue:** "Unable to find package"

**Solution:** Run `flutter pub get` to install dependencies

**Issue:** Analysis finds issues in generated files

**Solution:** Generated files (`.g.dart`, `.freezed.dart`) are excluded in `analysis_options.yaml`

### CI Checks Fail

**Issue:** CI fails but local checks pass

**Solution:** 
1. Pull latest changes: `git pull origin main`
2. Clean and reinstall: `flutter clean && flutter pub get`
3. Run checks again: `./scripts/check-quality.sh`

## Skipping Hooks (Not Recommended)

In rare cases, you may need to skip pre-commit hooks:

```bash
git commit --no-verify -m "message"
```

**Warning:** Only use this when absolutely necessary. CI will still catch issues.

## Customizing Rules

To modify linter rules:

1. Edit `analysis_options.yaml`
2. Add or remove rules under the `linter.rules` section
3. Run `dart analyze` to verify changes
4. Update this documentation if needed

See [Dart Linter Rules](https://dart.dev/tools/linter-rules) for available rules.

## Getting Help

If you encounter issues with code quality tools:

1. Check this documentation
2. Review the [CONTRIBUTING.md](../CONTRIBUTING.md) guide
3. Open an issue on GitHub
4. Ask in pull request discussions

## References

- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Flutter Lints Package](https://pub.dev/packages/flutter_lints)
- [Dart Linter Rules](https://dart.dev/tools/linter-rules)
- [Pre-commit Framework](https://pre-commit.com/)
