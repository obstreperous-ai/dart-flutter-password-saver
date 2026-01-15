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

### Prerequisites

- Flutter SDK (>= 3.0.0)
- For Linux: GTK+ 3.0 development libraries
- For macOS: Xcode and CocoaPods

### Installation

1. Clone the repository:
```bash
git clone https://github.com/obstreperous-ai/dart-flutter-password-saver.git
cd dart-flutter-password-saver
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
