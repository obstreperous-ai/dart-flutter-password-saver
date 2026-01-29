# Copilot Instructions for Password Saver

## Project Overview
This is a cross-platform desktop password saver app built with Flutter and Dart. It features secure encrypted storage using AES-256 encryption with OS-backed secure storage for encryption keys.

## Tech Stack
- **Flutter SDK**: >= 3.0.0
- **Dart**: >= 3.0.0
- **Target Platforms**: macOS and Linux desktop
- **Key Dependencies**:
  - `flutter_secure_storage` (^10.0.0) - OS-backed secure storage for encryption keys
  - `encrypt` (^5.0.3) - AES encryption for password data
  - `path_provider` (^2.1.1) - Access to application document directory

## Project Structure
```
lib/
├── main.dart          # Application entry point with MaterialApp setup
├── storage.dart       # Encrypted storage logic with AES encryption
└── ui/
    └── home_page.dart # UI widgets for password management
```

## Code Style & Conventions

### Dart Best Practices
- Use `const` constructors wherever possible (`prefer_const_constructors`)
- Use `const` for immutable collections (`prefer_const_literals_to_create_immutables`)
- Use `const` declarations when values won't change (`prefer_const_declarations`)
- Avoid using `print()` for output; use proper logging mechanisms (`avoid_print`)
- Follow Material Design 3 conventions for UI components
- Use `useMaterial3: true` for theming

### Security Requirements
- **CRITICAL**: Never store encryption keys or passwords in plain text
- Always use `flutter_secure_storage` for sensitive data like encryption keys
- Use AES-256 encryption for all password data before writing to disk
- Encryption keys must be 32 bytes (256 bits)
- Initialization vectors (IV) must be 16 bytes (128 bits)
- Always initialize encryption before performing any storage operations
- Handle encryption/decryption errors gracefully with try-catch blocks
- Log errors using proper logging (never use `print()` for sensitive data)
- Return Result types or throw custom exceptions for error conditions
- Provide user-friendly error messages in UI

### Naming Conventions
- Use descriptive class names (e.g., `PasswordEntry`, `EncryptedPasswordStorage`)
- Private fields and methods should be prefixed with underscore (e.g., `_secureStorage`, `_keyName`)
- Use camelCase for variable and method names
- Use PascalCase for class names
- Constants should use camelCase with descriptive names

### Error Handling
- Wrap file operations in try-catch blocks
- Return empty lists instead of throwing errors for missing data files
- Provide clear error messages when encryption is not initialized
- Handle secure storage read/write failures gracefully
- Wrap encryption operations in try-catch blocks
- Log errors appropriately without exposing sensitive data

## Test-Driven Development (TDD) Best Practices

This project follows TDD principles. **Always write or update tests when making code changes.**

### Test-First Development Flow

**When adding NEW features:**
1. Write failing tests first that define expected behavior
2. Run `flutter test` and verify tests fail (Red phase)
3. Implement minimal code to make tests pass
4. Run `flutter test` and verify tests now pass (Green phase)
5. Refactor if needed, re-running tests after each change (Refactor phase)
6. Proceed to Mandatory Quality Gates checklist

**When fixing BUGS:**
1. Write a test that reproduces the bug
2. Verify the test fails
3. Fix the bug in production code
4. Verify the test now passes
5. Proceed to Mandatory Quality Gates checklist

### Testing Guidelines
- Write tests **before** implementing features when adding new functionality
- Run tests **after** making any code changes to verify correctness
- Run tests after every significant code modification during development
- Keep tests focused, readable, and maintainable
- Follow the Arrange-Act-Assert (AAA) pattern in test structure
- Use descriptive test names that explain what is being tested
- Group related tests using `group()` blocks
- Mock external dependencies to isolate unit tests
- Test edge cases, error conditions, and boundary values

### Test Organization
```
test/
├── unit/           # Unit tests for individual classes/functions
├── widget/         # Widget tests for UI components  
└── integration/    # Integration tests for full workflows
```

### Writing Good Tests
```dart
// Good: Descriptive name, clear structure
test('fromJson should throw FormatException when JSON is malformed', () {
  // Arrange
  final invalidJson = {'invalid': 'data'};
  
  // Act & Assert
  expect(
    () => PasswordEntry.fromJson(invalidJson),
    throwsA(isA<FormatException>()),
  );
});

// Bad: Vague name, unclear purpose
test('test1', () {
  expect(something, true);
});
```

## Mandatory Quality Gates

**CRITICAL**: Execute these steps IN ORDER before any commit or PR creation. If ANY step fails, fix it and restart from step 1.

### Pre-Commit Workflow Checklist

#### 1. Install Dependencies
```bash
flutter pub get
```
- **Must complete**: Exit code 0, all dependencies resolved
- **If fails**: Check pubspec.yaml for syntax errors or version conflicts
- **Do not proceed** if dependencies fail to install

#### 2. Format Code
```bash
dart format .
```
- **Must complete**: Exit code 0 (no formatting changes needed)
- **If code was reformatted**: Review the changes to ensure they're reasonable
- **Action**: If formatting was applied, restart this checklist from step 1
- **Do not proceed** with unformatted code

#### 3. Run Static Analysis
```bash
dart analyze --fatal-infos
```
- **Must complete**: ZERO errors, warnings, or infos
- **If fails**: Read error output carefully and fix each issue in code
- **Action**: After fixing issues, re-run `dart analyze --fatal-infos`
- **Do not proceed** until analysis is completely clean

#### 4. Run All Tests
```bash
flutter test
```
- **Must complete**: ALL tests pass, exit code 0, 100% pass rate
- **If fails**: Read test failure output carefully
  - Determine if bug is in production code or test code
  - Fix the issue
  - Re-run `flutter test`
- **Do not proceed** if any tests fail
- **Do not proceed** if tests are skipped without good reason

#### 5. Verify Linux Build
```bash
flutter build linux
```
- **Must complete**: Successful build with exit code 0
- **If fails**: Read compilation error output
  - Fix syntax, type, or dependency errors in code
  - Re-run `flutter build linux`
- **Do not proceed** if build fails

#### 6. Verify macOS Build
```bash
flutter build macos
```
- **Must complete**: Successful build with exit code 0
- **If fails**: Read compilation error output
  - Fix syntax, type, or dependency errors in code
  - Re-run `flutter build macos`
- **Do not proceed** if build fails

#### 7. Final Code Review
Before creating a PR or committing, verify:
- [ ] No debug code remains (no `debugPrint`, test scaffolding, etc.)
- [ ] No `print()` statements for logging (use proper logging)
- [ ] No TODO comments left unaddressed (move to issues if needed)
- [ ] No hardcoded secrets, keys, or sensitive test data
- [ ] All new code follows conventions in this document
- [ ] All changed files have been reviewed
- [ ] Commit message is clear and descriptive

### Quick Pre-Commit Command Chain

For efficiency, chain commands together (stops at first failure):
```bash
flutter pub get && \
  dart format . && \
  dart analyze --fatal-infos && \
  flutter test && \
  flutter build linux && \
  flutter build macos
```

**Note**: This command chain will stop immediately when any command fails, making it easy to identify which check needs attention.

### When Build Commands Cannot Be Executed

If you are in an environment where builds cannot be executed (e.g., limited CI agent, containerized environment):
1. **Explicitly state this limitation** in the PR description
2. **List all quality checks that WERE completed** (formatting, analysis, tests)
3. **Add a warning** that builds must be verified locally before merging
4. **Label the PR** appropriately (e.g., "needs-build-verification")

### Handling Quality Gate Failures

#### If `dart analyze` fails:
1. Read the error/warning output carefully (each line indicates a problem)
2. Fix each issue in the code (do not ignore warnings)
3. Re-run `dart analyze --fatal-infos`
4. **Do NOT proceed** until zero issues remain
5. If you believe a warning is a false positive, document why and use `// ignore: rule_name` sparingly

#### If `flutter test` fails:
1. Read the test failure output carefully
2. Identify which test failed and why
3. Determine if the bug is in production code or test code
4. Fix the issue
5. Re-run `flutter test`
6. **Do NOT proceed** until all tests pass
7. If a test is flaky, fix the flakiness rather than ignoring it

#### If `dart format` makes changes:
1. Review what was reformatted
2. Restart the checklist from step 1
3. **Do NOT** manually override formatter preferences

#### If builds fail (`flutter build linux` or `flutter build macos`):
1. Read the compilation error output carefully
2. Fix syntax errors, type errors, or import issues
3. Re-run the build command
4. **Do NOT proceed** until build succeeds
5. If build fails with platform-specific issues, check dependencies in `pubspec.yaml`

## Definition of Done

Work is **ONLY** complete and ready for PR/commit when ALL of the following are true:

- [ ] All code follows conventions documented in this file
- [ ] All tests pass with 100% pass rate (`flutter test`)
- [ ] Code is properly formatted (`dart format .` makes no changes)
- [ ] Static analysis returns zero issues (`dart analyze --fatal-infos`)
- [ ] Linux build succeeds (`flutter build linux`)
- [ ] macOS build succeeds (`flutter build macos`)
- [ ] No security violations (no plain-text secrets, proper encryption usage)
- [ ] No `print()` statements for logging
- [ ] No debug code or TODOs remain
- [ ] Manual testing performed for UI/feature changes (when applicable)
- [ ] PR description explains what changed and why
- [ ] New features include appropriate tests
- [ ] Bug fixes include regression tests

**If any item above is not checked, the work is NOT complete.**

## Build, Lint, and Test Commands

### Get Dependencies
```bash
flutter pub get
```
Run this **first** after cloning or when dependencies change.

### Running Tests
```bash
flutter test
```
- Runs all tests in the `test/` directory
- Use `flutter test test/specific_test.dart` to run a single test file
- Use `flutter test --coverage` to generate coverage reports
- **Must be run** after every code change during development

### Formatting
```bash
dart format .
```
- Automatically formats all Dart code to match project style
- Must be run before committing to ensure consistent formatting
- Returns exit code 0 if already formatted, non-zero if changes were made

### Linting
```bash
dart analyze
```
- Uses rules defined in `analysis_options.yaml`
- Includes `package:flutter_lints/flutter.yaml` with custom rules
- Use `dart analyze --fatal-infos` for strictest checking (used in CI)

### Build Commands
**Always verify builds pass before considering a task complete.**

**Linux Build:**
```bash
flutter build linux
```

**macOS Build:**
```bash
flutter build macos
```

### Running the App
- **Linux**: `flutter run -d linux`
- **macOS**: `flutter run -d macos`

### Enable Desktop Support (if needed)
```bash
flutter config --enable-linux-desktop
flutter config --enable-macos-desktop
```

## Development Guidelines

### When Adding New Features (TDD Approach)
1. **Write Tests First** (Red phase)
   - Write failing tests that define the expected behavior
   - Tests should be specific and cover edge cases
   - Run `flutter test` to verify tests fail as expected

2. **Implement Feature** (Green phase)
   - Write minimal code to make tests pass
   - Focus on functionality, not perfection
   - Run `flutter test` frequently to check progress

3. **Refactor** (Refactor phase)
   - Clean up code while keeping tests passing
   - Apply SOLID principles and design patterns
   - Improve naming, structure, and performance
   - Run `flutter test` after each refactoring step

4. **Validate**
   - Run through the Mandatory Quality Gates checklist
   - Ensure all tests pass
   - Run linter and fix any issues
   - Build the application to verify compilation
   - Manually test the feature

5. **Document**
   - Update relevant documentation
   - Add code comments for complex logic
   - Update CHANGELOG if applicable

### When Modifying Existing Code
- **Always** run existing tests before making changes (baseline)
- Write new tests for bug fixes to prevent regression
- Update existing tests if behavior intentionally changes
- Run `flutter test` after each significant change
- Maintain the existing project structure
- Keep security as the top priority
- Add appropriate error handling
- Follow the existing code style
- Run through Mandatory Quality Gates before committing

### When Modifying Storage Logic
- **Critical**: Write tests for all storage operations
- Never modify `storage.dart` without ensuring backward compatibility
- Test encryption/decryption thoroughly with various inputs
- Test error conditions (file not found, corrupt data, etc.)
- Ensure secure storage operations are atomic
- Maintain the existing JSON serialization format for `PasswordEntry`
- Add tests for data migration if format changes
- Verify encryption keys are never exposed in logs or errors

### When Modifying UI
- Write widget tests for new UI components
- Test user interactions (button clicks, text input, etc.)
- Test different states (loading, error, success)
- Use Material Design 3 components
- Maintain consistency with existing UI patterns
- Use `const` constructors for widgets where possible
- Follow Flutter best practices for state management
- Verify changes manually by running the app
- Test both Linux and macOS platforms if UI is platform-specific

### Security Checklist
When making changes, verify:
- [ ] No hardcoded passwords or keys
- [ ] All sensitive data encrypted before storage
- [ ] Encryption keys stored in OS keychain/keyring via `flutter_secure_storage`
- [ ] No sensitive data in logs or print statements
- [ ] Proper error handling for security operations that doesn't leak sensitive info
- [ ] Input validation for user-provided data
- [ ] No sensitive data in test files or fixtures

## Things to Never Do
- Never commit secrets, API keys, or encryption keys to source control
- Never use weak encryption algorithms or short keys
- Never store passwords in plain text
- Never modify security-critical code without thorough understanding and testing
- Never remove or bypass encryption mechanisms
- Never use `print()` to output sensitive information
- Never introduce breaking changes to the storage format without migration logic
- **Never skip the Mandatory Quality Gates checklist**
- **Never commit code with failing tests**
- **Never commit code that doesn't build successfully**
- **Never ignore linter warnings or errors**
- **Never create a PR without running through the Definition of Done checklist**

## Troubleshooting

### Test Failures

**Issue:** Tests fail with "Unable to find package" or import errors

**Solution:** 
```bash
flutter clean
flutter pub get
flutter test
```

**Issue:** Tests pass locally but fail in CI

**Solution:**
1. Ensure Flutter SDK version matches CI (check `.github/workflows/build-test.yml`)
2. Run tests with same flags as CI: `flutter test --no-pub`
3. Check if tests depend on local files or environment variables

**Issue:** Widget tests fail with rendering errors

**Solution:**
```bash
flutter test --platform=chrome  # For web-specific widget tests
flutter test test/widget/      # Run only widget tests
```

### Build Failures

**Issue:** `flutter build` fails with CMake errors (Linux)

**Solution:**
```bash
# Install required dependencies
sudo apt-get update
sudo apt-get install clang ninja-build pkg-config libgtk-3-dev libsecret-1-dev
```

**Issue:** Build fails with "flutter_secure_storage" errors

**Solution:**
```bash
flutter clean
flutter pub get
flutter pub upgrade flutter_secure_storage
```

**Issue:** Build succeeds but app crashes on startup

**Solution:**
1. Check logs: `flutter run -d linux -v`
2. Verify encryption initialization in `storage.dart`
3. Check for missing platform-specific dependencies

### Formatting Issues

**Issue:** `dart format` changes too many files

**Solution:**
- This is expected - commit the formatting changes separately
- Configure your IDE to format on save to avoid bulk changes

**Issue:** Formatting conflicts with linter

**Solution:**
- Always run `dart format .` before `dart analyze`
- Formatter takes precedence over manual style

### Linting Issues

**Issue:** `dart analyze` reports errors in generated files

**Solution:**
- Generated files (`.g.dart`, `.freezed.dart`) are excluded in `analysis_options.yaml`
- If still appearing, run `flutter clean && flutter pub get`

**Issue:** Too many linting warnings to fix

**Solution:**
- Fix errors first (red), then warnings (yellow)
- Use `// ignore: rule_name` for false positives (sparingly)
- Run `dart fix --apply` to auto-fix some issues

**Issue:** Linter reports unused imports after formatting

**Solution:**
```bash
dart fix --apply  # Auto-removes unused imports
dart analyze      # Verify
```

### Dependency Issues

**Issue:** `flutter pub get` fails with version conflicts

**Solution:**
```bash
flutter pub upgrade --major-versions  # Carefully review changes
# Or update specific package
flutter pub upgrade package_name
```

**Issue:** Dependency vulnerabilities detected

**Solution:**
1. Check `.github/workflows/dependency-scan.yml` for details
2. Update vulnerable packages: `flutter pub upgrade`
3. Review breaking changes in package changelogs

### CI/CD Issues

**Issue:** Code quality workflow fails but local checks pass

**Solution:**
```bash
# Run same commands as CI
dart format --set-exit-if-changed .
dart analyze --fatal-infos
flutter test
```

**Issue:** Build workflow times out

**Solution:**
- Ensure no infinite loops in code
- Check for blocking I/O operations
- Review recent changes that might affect build time

### Getting Help

If you encounter persistent issues:
1. Check this documentation thoroughly
2. Review similar issues in GitHub repository
3. Check [Flutter documentation](https://docs.flutter.dev/)
4. Review [Dart language tour](https://dart.dev/guides/language/language-tour)
5. Ask in project discussions or open an issue

## Additional Notes
- The app uses a dev container for development (see `.devcontainer/`)
- The project follows Flutter lints standard with additional const preferences
- All password data is stored in an encrypted file (`passwords.enc`) in the app's document directory
- The app targets desktop platforms only (no mobile support currently)
- Review the [CODE_QUALITY.md](../docs/CODE_QUALITY.md) for comprehensive quality guidelines

---

## Summary of Key Improvements

This revised instruction set includes:
1. **Mandatory Quality Gates**: Clear, numbered checklist that must be completed before any commit
2. **Explicit Failure Handling**: Detailed instructions for what to do when each check fails
3. **Definition of Done**: Comprehensive checklist to determine if work is truly complete
4. **Stronger TDD Guidance**: Clear workflows for when to write tests and how to integrate them
5. **Security Enhancements**: More specific requirements for error handling and logging
6. **Command Chain**: Quick verification script that stops at first failure
7. **No Ambiguity**: Clear "Do NOT proceed" language when checks fail

These changes should significantly improve Copilot's ability to deliver code that passes quality checks and builds successfully on the first try.