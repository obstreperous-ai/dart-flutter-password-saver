# Copilot Instructions for Password Saver

## Project Overview
This is a cross-platform desktop password saver app built with Flutter and Dart. It features secure encrypted storage using AES-256 encryption with OS-backed secure storage for encryption keys.

## Tech Stack
- **Flutter SDK**: >= 3.0.0
- **Dart**: >= 3.0.0
- **Target Platforms**: macOS and Linux desktop
- **Key Dependencies**:
  - `flutter_secure_storage` (^9.0.0) - OS-backed secure storage for encryption keys
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
- Handle encryption/decryption errors gracefully

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

## Test-Driven Development (TDD) Best Practices

This project follows TDD principles. Always write or update tests when making code changes.

### Testing Guidelines
- Write tests **before** implementing features when adding new functionality
- Run tests **after** making any code changes to verify correctness
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

## Pre-Commit Workflow

**CRITICAL**: Before committing any code changes, you **MUST** complete these steps in order. This workflow ensures code quality and prevents CI failures.

### Step-by-Step Pre-Commit Process

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```
   Ensures all dependencies are installed and up-to-date.

2. **Run Tests** ⚠️ **DO THIS FIRST**
   ```bash
   flutter test
   ```
   - Verify all tests pass with your changes
   - If tests fail, fix the code or update tests appropriately
   - **NEVER** commit code with failing tests
   - If adding new features, ensure new tests are included

3. **Format Code**
   ```bash
   dart format .
   ```
   - Automatically formats code to project standards
   - This **must** be done after tests pass to avoid conflicts
   - Re-run tests if formatter makes significant changes

4. **Lint Code**
   ```bash
   dart analyze
   ```
   - Checks for code quality issues, potential bugs, and style violations
   - Fix all errors and warnings before proceeding
   - Use `dart analyze --fatal-infos` for strictest checking (same as CI)

5. **Build Application**
   ```bash
   # For Linux
   flutter build linux
   
   # For macOS
   flutter build macos
   ```
   - Verifies the application compiles successfully
   - Catches compilation errors that might not appear in tests
   - **Required** before commit - if build fails, your changes are incomplete

6. **Verify Changes Manually** (when applicable)
   ```bash
   flutter run -d linux  # or -d macos
   ```
   - Test UI changes by running the application
   - Verify new features work as expected
   - Check that existing functionality still works

### Quick Pre-Commit Command Chain

For efficiency, you can chain commands together:
```bash
flutter pub get && \
flutter test && \
dart format . && \
dart analyze && \
flutter build linux
```

This will stop at the first failure, making it easy to identify issues.

### ⚠️ Common Mistakes to Avoid

- ❌ **Don't** format before running tests - formatted code might still have logic errors
- ❌ **Don't** skip tests because they're slow - failing tests mean broken code
- ❌ **Don't** commit with linting warnings - they indicate code quality issues
- ❌ **Don't** assume CI will catch issues - run checks locally first
- ❌ **Don't** skip the build step - tests passing doesn't guarantee compilation
- ✅ **Do** follow the exact order: Dependencies → Tests → Format → Lint → Build

### All Checks Must Pass

Your code is **not ready to commit** unless:
- ✅ All tests pass (`flutter test`)
- ✅ Code is formatted (`dart format .`)
- ✅ No linting errors (`dart analyze`)
- ✅ Application builds successfully (`flutter build`)
- ✅ Manual testing confirms changes work (for UI/feature changes)

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
- Maintain the existing project structure
- Keep security as the top priority
- Add appropriate error handling
- Follow the existing code style

### When Modifying Storage Logic
- **Critical**: Write tests for all storage operations
- Never modify `storage.dart` without ensuring backward compatibility
- Test encryption/decryption thoroughly with various inputs
- Test error conditions (file not found, corrupt data, etc.)
- Ensure secure storage operations are atomic
- Maintain the existing JSON serialization format for `PasswordEntry`
- Add tests for data migration if format changes

### When Modifying UI
- Write widget tests for new UI components
- Test user interactions (button clicks, text input, etc.)
- Test different states (loading, error, success)
- Use Material Design 3 components
- Maintain consistency with existing UI patterns
- Use `const` constructors for widgets where possible
- Follow Flutter best practices for state management
- Verify changes manually by running the app

### Security Checklist
When making changes, verify:
- No hardcoded passwords or keys
- All sensitive data encrypted before storage
- Encryption keys stored in OS keychain/keyring
- No sensitive data in logs or print statements
- Proper error handling for security operations
- Input validation for user-provided data

## Things to Never Do
- Never commit secrets, API keys, or encryption keys to source control
- Never use weak encryption algorithms or short keys
- Never store passwords in plain text
- Never modify security-critical code without thorough understanding
- Never remove or bypass encryption mechanisms
- Never use `print()` to output sensitive information
- Never introduce breaking changes to the storage format without migration logic

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
