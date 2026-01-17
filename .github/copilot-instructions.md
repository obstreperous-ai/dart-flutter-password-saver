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

## Build, Lint, and Test Commands

### Linting
```bash
dart analyze
```
Uses `analysis_options.yaml` which includes `package:flutter_lints/flutter.yaml` with custom rules.

### Get Dependencies
```bash
flutter pub get
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

### When Adding New Features
- Maintain the existing project structure
- Keep security as the top priority
- Add appropriate error handling
- Follow the existing code style
- Update documentation if adding new functionality

### When Modifying Storage Logic
- Never modify `storage.dart` without ensuring backward compatibility
- Test encryption/decryption thoroughly
- Ensure secure storage operations are atomic
- Maintain the existing JSON serialization format for `PasswordEntry`

### When Modifying UI
- Use Material Design 3 components
- Maintain consistency with existing UI patterns
- Use `const` constructors for widgets where possible
- Follow Flutter best practices for state management

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

## Additional Notes
- The app uses a dev container for development (see `.devcontainer/`)
- The project follows Flutter lints standard with additional const preferences
- All password data is stored in an encrypted file (`passwords.enc`) in the app's document directory
- The app targets desktop platforms only (no mobile support currently)
