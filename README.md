# 🔐 Password Saver

A secure, cross-platform desktop password manager built with Flutter and Dart, featuring military-grade AES-256 encryption and OS-backed secure storage.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.0.0-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.0.0-0175C2?logo=dart)](https://dart.dev)

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Security Architecture](#security-architecture)
- [Getting Started](#getting-started)
  - [Dev Container Setup](#dev-container-setup-recommended)
  - [Manual Installation](#manual-installation)
- [Usage](#usage)
- [Development](#development)
- [Architecture for Agentic Workflows](#architecture-for-agentic-workflows)
- [Contributing](#contributing)
- [Security Notes](#security-notes)
- [License](#license)

## 🎯 Overview

Password Saver is a secure desktop application for managing your passwords and credentials. Unlike cloud-based password managers, this application stores all data locally on your device with industry-standard encryption, giving you complete control over your sensitive information.

**Target Platforms:**
- 🐧 Linux (GTK+ 3.0)
- 🍎 macOS (10.14+)

**Built with:**
- **Flutter** - Google's UI toolkit for building natively compiled applications
- **Dart** - Client-optimized language for fast apps on any platform

## ✨ Features

### Security First
- 🔒 **AES-256 Encryption** - Military-grade encryption for all password data
- 🗝️ **OS Keychain Integration** - Encryption keys stored in macOS Keychain or Linux Secret Service
- 🛡️ **Zero Knowledge** - All data is encrypted locally; no cloud storage or third-party access
- 🔐 **Secure Random Key Generation** - Cryptographically secure key and IV generation

### User Experience
- 🎨 **Material Design 3** - Clean, modern interface following Google's design guidelines
- 🔍 **Search Functionality** - Quickly find passwords by title or username
- ✏️ **Easy Management** - Add, edit, and delete password entries with a simple UI
- 📋 **Copy to Clipboard** - One-click password copying
- 👁️ **Password Visibility Toggle** - Show/hide passwords when needed
- 📝 **Notes Support** - Add additional notes to each password entry

### Developer Experience
- 🐳 **Dev Container Support** - Get started in seconds with pre-configured development environment
- 🧪 **Code Quality Tools** - Automated linting, formatting, and static analysis
- 🔄 **CI/CD Integration** - GitHub Actions workflows for quality checks and builds
- 📚 **Comprehensive Documentation** - Well-documented code and processes

## 🔒 Security Architecture

### Encryption System

Password Saver uses a defense-in-depth approach to protect your sensitive data:

```
┌─────────────────────────────────────────────────────────────┐
│                     User Interface                          │
│              (Material Design 3 Flutter UI)                 │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                Application Logic Layer                      │
│           (Password Management & Validation)                │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│              Encrypted Storage Layer                        │
│                 (storage.dart)                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  1. Serialize passwords to JSON                       │  │
│  │  2. Encrypt with AES-256-CBC                          │  │
│  │  3. Write encrypted data to disk                      │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────┬───────────────────────────────────────┘
                      │
        ┌─────────────┴─────────────┐
        │                           │
        ▼                           ▼
┌─────────────────┐        ┌────────────────────┐
│  OS Keychain    │        │  Encrypted File    │
│   (Secure)      │        │  passwords.enc     │
│                 │        │ (App Documents)    │
│ - Encryption    │        │                    │
│   Key (32 bytes)│        │ - Base64 Encoded   │
│ - IV (16 bytes) │        │ - AES Encrypted    │
│                 │        │ - JSON Data        │
└─────────────────┘        └────────────────────┘
```

### Key Components

1. **Encryption Keys** (`storage.dart`)
   - **Algorithm**: AES-256 in CBC mode
   - **Key Size**: 32 bytes (256 bits)
   - **IV Size**: 16 bytes (128 bits)
   - **Key Generation**: Cryptographically secure random generation
   - **Key Storage**: OS-backed secure storage (Keychain/Secret Service)

2. **Data Storage**
   - Passwords stored in `passwords.enc` in application documents directory
   - Data encrypted before writing to disk
   - JSON serialization for structured data
   - Base64 encoding for encrypted output

3. **OS Security Integration**
   - **macOS**: Keychain Services (encrypted SQLite database in `/Library/Keychains`)
   - **Linux**: Secret Service API (gnome-keyring, KWallet, etc.)
   - Keys never stored in plain text on disk
   - Protected by OS-level authentication

### Security Guarantees

✅ **Confidentiality** - AES-256 encryption ensures data cannot be read without the encryption key  
✅ **Key Protection** - Encryption keys stored in OS keychain, protected by system authentication  
✅ **Data Isolation** - Each application instance has its own encryption key  
✅ **No Cloud Exposure** - All data stored locally; no network transmission  
✅ **Secure Defaults** - Encryption initialized before any data operations  

### Security Limitations

⚠️ **Important**: While Password Saver uses strong encryption, users should be aware of:

- **Physical Access**: An attacker with physical access to an unlocked device can access passwords
- **Memory Attacks**: Passwords are decrypted in memory when displayed or edited
- **OS Trust**: Security relies on the integrity of the operating system's keychain
- **No Password Recovery**: Lost encryption keys mean lost data (by design)
- **No Multi-Device Sync**: Each installation maintains separate encrypted storage

## 🚀 Getting Started

### Dev Container Setup (Recommended)

The fastest way to get started is using Visual Studio Code with Dev Containers. This provides a pre-configured development environment with all dependencies.

#### Prerequisites
- [Docker](https://www.docker.com/get-started)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

#### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/obstreperous-ai/dart-flutter-password-saver.git
   cd dart-flutter-password-saver
   ```

2. **Open in VS Code:**
   ```bash
   code .
   ```

3. **Reopen in Container:**
   - When prompted, click **"Reopen in Container"**
   - Or use Command Palette (Ctrl/Cmd+Shift+P) → **"Dev Containers: Reopen in Container"**

4. **Wait for setup to complete** (first time only)
   The container will automatically:
   - Install Flutter SDK (stable channel)
   - Install Linux desktop dependencies (GTK+, etc.)
   - Run `flutter pub get` to fetch dependencies
   - Run `flutter doctor` to verify setup
   - Install git hooks for code quality
   - Run `dart analyze` to check code quality

5. **Run the application:**
   ```bash
   flutter run -d linux
   ```

### Manual Installation

If you prefer not to use Dev Containers, follow these steps for manual setup.

#### Prerequisites

- **Flutter SDK** >= 3.0.0 ([installation guide](https://docs.flutter.dev/get-started/install))
- **Dart SDK** >= 3.0.0 (included with Flutter)

**Platform-Specific Requirements:**

**Linux:**
- GTK+ 3.0 development libraries
- Additional dependencies:
  ```bash
  sudo apt-get update
  sudo apt-get install -y \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    libstdc++-12-dev \
    libsecret-1-dev
  ```

**macOS:**
- Xcode (from App Store)
- CocoaPods (install via `sudo gem install cocoapods`)

#### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/obstreperous-ai/dart-flutter-password-saver.git
   cd dart-flutter-password-saver
   ```

2. **Enable desktop support:**
   ```bash
   flutter config --enable-linux-desktop    # For Linux
   flutter config --enable-macos-desktop    # For macOS
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Verify setup:**
   ```bash
   flutter doctor
   ```

5. **Install git hooks (optional but recommended):**
   ```bash
   ./scripts/install-git-hooks.sh
   ```

#### Running the Application

**Linux:**
```bash
flutter run -d linux
```

**macOS:**
```bash
flutter run -d macos
```

#### Building Release Versions

**Linux:**
```bash
flutter build linux --release
# Executable will be in: build/linux/x64/release/bundle/
```

**macOS:**
```bash
flutter build macos --release
# Application will be in: build/macos/Build/Products/Release/
```

## 📖 Usage

### First Launch

1. Launch the application using `flutter run -d linux` or `flutter run -d macos`
2. On first launch, the app will:
   - Generate a new 256-bit encryption key
   - Generate a 128-bit initialization vector (IV)
   - Store both securely in the OS keychain
   - Initialize the encrypted storage system

### Managing Passwords

#### Adding a Password

1. Click the **+** (Add) button in the bottom-right corner
2. Fill in the password details:
   - **Title**: Name for this password (e.g., "GitHub Account")
   - **Username/Email**: Your username or email for this account
   - **Password**: The password to store
   - **Notes** (optional): Additional information
3. Click the **Save** icon in the top-right corner

#### Viewing/Editing a Password

1. Click on any password entry in the list
2. View or modify the details
3. Use the eye icon to toggle password visibility
4. Use the copy icon to copy the password to clipboard
5. Click **Save** to save changes

#### Searching for Passwords

1. Use the search bar at the top of the main screen
2. Type any part of the title or username
3. Results filter in real-time

#### Deleting a Password

1. Click the trash icon on any password entry
2. Confirm the deletion in the dialog
3. The password is permanently removed and storage is updated

### Data Location

Password Saver stores data in the following locations:

**Linux:**
- Encrypted passwords: `~/.local/share/password_saver/passwords.enc`
- Encryption keys: GNOME Keyring / Secret Service

**macOS:**
- Encrypted passwords: `~/Library/Application Support/password_saver/passwords.enc`
- Encryption keys: macOS Keychain

### Backup and Recovery

⚠️ **Important**: There is no password recovery mechanism by design. If you lose access to your encryption keys, your passwords cannot be recovered.

**To backup your passwords:**

1. Export the encrypted file and keys (manual process):
   - Encrypted data: Copy `passwords.enc` from the data location
   - Keys: Cannot be exported directly from keychain (security feature)

2. Consider exporting passwords to a secure format before uninstalling or changing systems

**Note**: Future versions may include a built-in export feature with master password protection.

## 🛠️ Development

### Code Quality Standards

Password Saver maintains high code quality through automated checks and strict linting rules.

#### Pre-commit Hooks

Install automated quality checks before committing:

```bash
# Option 1: Simple git hooks (recommended)
./scripts/install-git-hooks.sh

# Option 2: Pre-commit framework (requires Python)
./setup-hooks.sh
```

#### Manual Quality Checks

Run all quality checks:
```bash
./scripts/check-quality.sh
```

Or run individual checks:

```bash
# Format code
dart format .

# Static analysis
dart analyze --fatal-infos

# Check dependencies
flutter pub outdated
```

#### Code Style Guidelines

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `const` constructors wherever possible
- Prefer single quotes for strings
- Add trailing commas for better formatting
- Avoid `print()` statements (use proper logging)
- Document public APIs with doc comments
- Keep lines under 80 characters when reasonable

See [`analysis_options.yaml`](analysis_options.yaml) for complete linting rules.

### Building and Testing

#### Development Build

```bash
# Run in debug mode
flutter run -d linux     # or macos

# Run with verbose logging
flutter run -d linux -v
```

#### Release Build

```bash
# Build for production
flutter build linux --release
flutter build macos --release
```

#### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze test coverage
genhtml coverage/lcov.info -o coverage/html
```

### Project Structure

```
password_saver/
├── lib/
│   ├── main.dart              # Application entry point
│   ├── storage.dart           # Encrypted storage implementation
│   └── ui/
│       └── home_page.dart     # UI components
├── linux/                     # Linux platform-specific code
├── macos/                     # macOS platform-specific code
├── test/                      # Unit and widget tests
├── docs/                      # Documentation
│   ├── CODE_QUALITY.md       # Code quality tools documentation
│   └── INTEGRATION_SUMMARY.md
├── scripts/                   # Development scripts
│   ├── check-quality.sh      # Run all quality checks
│   ├── install-git-hooks.sh  # Install git hooks
│   └── pre-commit-hook.sh    # Pre-commit hook script
├── .devcontainer/            # Dev Container configuration
│   └── devcontainer.json     # Container setup
├── .github/
│   └── workflows/            # CI/CD workflows
│       ├── build-test.yml    # Build and test workflow
│       ├── code-quality.yml  # Code quality checks
│       └── dependency-scan.yml
├── analysis_options.yaml     # Dart linter configuration
├── pubspec.yaml             # Package dependencies
└── README.md                # This file
```

### Dependencies

Core dependencies:
- **`flutter_secure_storage`** (^10.0.0) - OS keychain integration
- **`encrypt`** (^5.0.3) - AES encryption implementation
- **`path_provider`** (^2.1.1) - Application directories

Dev dependencies:
- **`flutter_test`** - Testing framework
- **`flutter_lints`** (^3.0.0) - Linting rules

### CI/CD Workflows

GitHub Actions workflows run automatically on pull requests and pushes:

1. **Code Quality** (`.github/workflows/code-quality.yml`)
   - Checks code formatting
   - Runs static analysis
   - Verifies no analysis warnings

2. **Build and Test** (`.github/workflows/build-test.yml`)
   - Builds for Linux and macOS
   - Runs test suite
   - Verifies cross-platform compatibility

3. **Dependency Scan** (`.github/workflows/dependency-scan.yml`)
   - Checks for outdated dependencies
   - Scans for security vulnerabilities
   - Runs weekly and on PRs

## 🤖 Architecture for Agentic Workflows

Password Saver is designed to be easily understood and modified by AI agents and agentic workflows. The architecture follows clear separation of concerns and includes comprehensive tooling for automated development.

### Design Principles for Agents

1. **Clear Separation of Concerns**
   - **UI Layer** (`ui/home_page.dart`) - All user interface components
   - **Storage Layer** (`storage.dart`) - All encryption and persistence logic
   - **Entry Point** (`main.dart`) - Application initialization and configuration

2. **Comprehensive Documentation**
   - **README.md** - User-facing documentation and setup instructions
   - **CONTRIBUTING.md** - Developer guidelines and contribution process
   - **docs/CODE_QUALITY.md** - Code quality tools and standards
   - **Copilot Instructions** (`.github/copilot-instructions.md`) - AI agent guidelines
   - **Inline Comments** - Complex logic explained in code

3. **Automated Quality Checks**
   - Pre-commit hooks validate code before committing
   - CI/CD workflows ensure quality on every PR
   - Static analysis catches bugs early
   - Formatting is automated and enforced

### Agent-Friendly Features

#### Self-Documenting Code
- Clear class and method names
- Type annotations on all public APIs
- Comprehensive doc comments
- Minimal magic or hidden behavior

#### Structured Configuration
- **`pubspec.yaml`** - All dependencies and metadata
- **`analysis_options.yaml`** - All linting rules
- **`.devcontainer/devcontainer.json`** - Development environment
- **`.github/workflows/`** - All CI/CD configurations

#### Testability
- Pure functions for business logic
- Clear interfaces between components
- Dependency injection where appropriate
- Mockable dependencies

### Workflow Integration Points

Agentic workflows can integrate with this project at multiple levels:

1. **Code Modification**
   - Read code structure from project files
   - Modify specific components (UI, storage, etc.)
   - Run quality checks: `dart format .` and `dart analyze`
   - Verify changes: `flutter build linux`

2. **Testing and Validation**
   - Run automated tests: `flutter test`
   - Build for both platforms
   - Check CI/CD status via GitHub API
   - Validate security with dependency scans

3. **Documentation Updates**
   - Update README.md for feature changes
   - Modify CONTRIBUTING.md for process changes
   - Update copilot-instructions.md for agent guidance
   - Generate API documentation: `dart doc`

### Development Environment for Agents

The Dev Container provides a consistent, reproducible environment:

```json
{
  "name": "Flutter Password Saver",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/devcontainers-contrib/features/flutter-asdf:2": {
      "version": "stable",
      "channel": "stable"
    }
  },
  "postCreateCommand": "flutter pub get && flutter doctor"
}
```

Agents can leverage this to:
- Ensure consistent tooling versions
- Run tests in isolation
- Validate changes in clean environment
- Reproduce CI/CD environment locally

### Recommended Agent Workflow

1. **Analyze** - Read relevant files and understand current state
2. **Plan** - Determine minimal changes needed
3. **Modify** - Make focused, surgical changes
4. **Validate** - Run quality checks and tests
5. **Document** - Update documentation if needed
6. **Commit** - Create focused commits with clear messages

### Tools for Agents

Available scripts for automated workflows:

```bash
# Install development environment
./scripts/install-git-hooks.sh

# Run all quality checks
./scripts/check-quality.sh

# Format code
dart format .

# Analyze code
dart analyze --fatal-infos

# Build application
flutter build linux
flutter build macos

# Run tests
flutter test

# Check dependencies
flutter pub outdated
```

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Quick Start for Contributors

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/dart-flutter-password-saver.git`
3. Create a branch: `git checkout -b feature/your-feature-name`
4. Install dependencies: `flutter pub get`
5. Install hooks: `./scripts/install-git-hooks.sh`
6. Make your changes
7. Run quality checks: `./scripts/check-quality.sh`
8. Commit: `git commit -m "feat: your feature description"`
9. Push: `git push origin feature/your-feature-name`
10. Create a Pull Request

### Contribution Guidelines

- ✅ Follow Dart style guide and linting rules
- ✅ Add tests for new functionality
- ✅ Update documentation for user-facing changes
- ✅ Ensure all CI checks pass
- ✅ Keep security as top priority
- ✅ Make focused, minimal changes

See [CONTRIBUTING.md](CONTRIBUTING.md) for complete guidelines.

## 🔐 Security Notes

### Reporting Security Vulnerabilities

If you discover a security vulnerability, please **DO NOT** open a public issue. Instead:

1. Email the maintainers (see GitHub profile for contact)
2. Include detailed description of the vulnerability
3. Provide steps to reproduce if possible
4. Allow time for a fix before public disclosure

### Security Best Practices

When using Password Saver:

- ✅ Keep your operating system updated
- ✅ Use strong authentication on your device (password, biometrics)
- ✅ Lock your device when away
- ✅ Backup your encrypted password file
- ✅ Verify the application source (official repository)
- ❌ Never share your encryption keys
- ❌ Don't disable OS security features
- ❌ Don't install on untrusted systems

### Known Limitations

- **No cloud sync**: Passwords are local-only
- **No password recovery**: Lost keys = lost data
- **OS trust required**: Security depends on OS keychain integrity
- **Physical access risk**: Unlocked device = accessible passwords
- **Memory exposure**: Decrypted passwords visible in memory

### Security Audits

This is an open-source project and has not undergone formal security audits. Use at your own risk. We welcome security reviews and responsible disclosure of vulnerabilities.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2026 obstreperous-ai

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev) and [Dart](https://dart.dev)
- Uses [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) for OS keychain integration
- Uses [encrypt](https://pub.dev/packages/encrypt) for AES encryption
- Material Design 3 UI components

## 📞 Support

- 📚 [Documentation](docs/)
- 🐛 [Issue Tracker](https://github.com/obstreperous-ai/dart-flutter-password-saver/issues)
- 💬 [Discussions](https://github.com/obstreperous-ai/dart-flutter-password-saver/discussions)

---

**Made with ❤️ using Flutter and Dart**
