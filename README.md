# Password Saver

A cross-platform desktop password saver app built with Flutter, featuring secure encrypted storage.

## Features

- **Secure Storage**: Uses OS-backed secure storage via `flutter_secure_storage` to protect encryption keys
- **AES Encryption**: Password entries are encrypted using AES-256 encryption before being saved to disk
- **Cross-Platform**: Supports macOS and Linux desktop platforms
- **User-Friendly UI**: Clean Material Design interface for managing passwords
- **Search Functionality**: Quickly find passwords by title or username

## Project Structure

```
lib/
├── main.dart          # Application entry point
├── storage.dart       # Encrypted storage logic with AES encryption
└── ui/
    └── home_page.dart # UI widgets for password management
```

## Dependencies

- **flutter_secure_storage**: OS-backed secure storage for encryption keys
- **encrypt**: AES encryption for password data
- **path_provider**: Access to application document directory for encrypted file storage

## Setup and Running

### Using Dev Container (Recommended)

The easiest way to get started is using the provided Dev Container configuration:

1. Install [Docker](https://www.docker.com/get-started) and [VS Code](https://code.visualstudio.com/)
2. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for VS Code
3. Clone the repository:
```bash
git clone <repository-url>
```
4. Open the project in VS Code
5. When prompted, click "Reopen in Container" (or run "Dev Containers: Reopen in Container" from the command palette)

The dev container will automatically:
- Install Flutter SDK (stable channel)
- Install required Linux desktop dependencies
- Run `flutter pub get` to fetch dependencies
- Run `flutter doctor` to verify the setup
- Run `dart analyze` to check code quality

### Manual Installation

#### Prerequisites

- Flutter SDK (>= 3.0.0)
- For Linux: GTK+ 3.0 development libraries
- For macOS: Xcode and CocoaPods

#### Installation

1. Clone the repository:
```bash
git clone <repository-url>
```

2. Get Flutter dependencies:
```bash
flutter pub get
```

3. Enable desktop support (if not already enabled):
```bash
flutter config --enable-linux-desktop
flutter config --enable-macos-desktop
```

### Running the App

**On Linux:**
```bash
flutter run -d linux
```

**On macOS:**
```bash
flutter run -d macos
```

## Development Guidelines

### Code Quality and Formatting

This project maintains high code quality standards. Before submitting a PR, ensure your code passes all quality checks:

#### Automated Pre-commit Hooks

We provide git pre-commit hooks that automatically check code quality before each commit:

**Option 1: Simple Git Hooks (Recommended)**
```bash
./scripts/install-git-hooks.sh
```

**Option 2: Using pre-commit framework**
```bash
./setup-hooks.sh
```
This requires Python and pip to be installed.

#### Manual Code Quality Checks

If you prefer to run checks manually before committing:

1. **Format your code:**
```bash
dart format .
```

2. **Analyze code for issues:**
```bash
dart analyze --fatal-infos
```

3. **Check for dependency vulnerabilities:**
```bash
flutter pub outdated
```

#### What Gets Checked

- **Code Formatting**: Ensures consistent code style across the project
- **Static Analysis**: Catches potential bugs, code smells, and style issues
- **Dependency Security**: Identifies outdated or vulnerable dependencies

#### CI/CD Integration

All quality checks run automatically in CI:
- **Code Quality Workflow**: Runs formatting and analysis checks
- **Build and Test Workflow**: Builds for Linux and macOS
- **Dependency Scan Workflow**: Checks for vulnerable dependencies

### Before Submitting a PR

**Required steps before raising a pull request:**

1. ✅ Install and run pre-commit hooks OR manually run:
   - `dart format .`
   - `dart analyze --fatal-infos`
   
2. ✅ Ensure all files are properly formatted

3. ✅ Fix any analysis warnings or errors

4. ✅ Test your changes locally:
   - Linux: `flutter run -d linux`
   - macOS: `flutter run -d macos`

5. ✅ Check for dependency issues:
   - `flutter pub outdated`

6. ✅ Verify builds succeed:
   - Linux: `flutter build linux`
   - macOS: `flutter build macos`

**Note**: CI will automatically verify these checks. PRs that fail quality checks will not be merged.

## Security

- Encryption keys are stored securely using the operating system's keychain/keyring
- Password data is encrypted with AES-256 before being written to disk
- All sensitive data is encrypted at rest

## License

See LICENSE file for details.
