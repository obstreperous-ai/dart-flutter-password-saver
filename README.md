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

## Security

- Encryption keys are stored securely using the operating system's keychain/keyring
- Password data is encrypted with AES-256 before being written to disk
- All sensitive data is encrypted at rest

## License

See LICENSE file for details.
