# Contributing to Password Saver

Thank you for your interest in contributing to Password Saver! This document provides guidelines and instructions for contributing.

## Code Quality Standards

We maintain high code quality standards to ensure the security and reliability of this password management application.

### Required Checks Before Committing

All code changes must pass the following checks:

1. **Code Formatting** - Run `dart format .`
2. **Static Analysis** - Run `dart analyze --fatal-infos`
3. **Manual Testing** - Test your changes locally

### Setting Up Pre-commit Hooks

We strongly recommend setting up pre-commit hooks to automatically run quality checks:

```bash
# Simple approach - copy git hooks
./scripts/install-git-hooks.sh
```

Or using the pre-commit framework:

```bash
# Requires Python and pip
./setup-hooks.sh
```

### Code Style Guidelines

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `const` constructors wherever possible
- Avoid `print()` statements; use proper logging
- Add trailing commas for better formatting
- Keep lines under 80 characters when reasonable
- Use single quotes for strings
- Document public APIs with doc comments

### Analysis Options

The project uses a comprehensive set of linter rules defined in `analysis_options.yaml`:

- **Error Prevention**: Rules that catch potential bugs
- **Style Consistency**: Rules that enforce consistent code style
- **Performance**: Rules that encourage better performance
- **Security**: Rules that help prevent security issues

### Security Considerations

When contributing, please ensure:

- Never commit secrets, API keys, or encryption keys
- Use secure coding practices for handling sensitive data
- Encryption keys must be stored in OS secure storage
- All password data must be encrypted before storage
- Follow the principle of least privilege
- Validate all user inputs

## Pull Request Process

1. **Fork and Clone**: Fork the repository and clone it locally
   ```bash
   git clone https://github.com/YOUR_USERNAME/dart-flutter-password-saver.git
   cd dart-flutter-password-saver
   ```

2. **Create a Branch**: Create a feature branch for your changes
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

4. **Set Up Hooks**: Install pre-commit hooks
   ```bash
   ./scripts/install-git-hooks.sh
   ```

5. **Make Changes**: Write your code following our style guidelines

6. **Test Locally**:
   ```bash
   # Format code
   dart format .
   
   # Analyze code
   dart analyze --fatal-infos
   
   # Test on your platform
   flutter run -d linux  # or macos
   
   # Build to ensure no issues
   flutter build linux   # or macos
   ```

7. **Commit Changes**: Commit with clear, descriptive messages
   ```bash
   git add .
   git commit -m "Add feature: description of your changes"
   ```

8. **Push and Create PR**:
   ```bash
   git push origin feature/your-feature-name
   ```
   Then create a pull request on GitHub

9. **CI Checks**: Ensure all CI checks pass:
   - Code quality checks
   - Build verification
   - Dependency scanning

## Dependency Management

### Adding Dependencies

Before adding a new dependency:

1. Check if it's necessary - can you use existing dependencies?
2. Verify the package is well-maintained
3. Check for security advisories
4. Use specific version constraints in `pubspec.yaml`

### Updating Dependencies

```bash
# Check for outdated dependencies
flutter pub outdated

# Update dependencies
flutter pub upgrade

# Test after updates
flutter test
```

## Testing

While writing tests is not mandatory for all contributions, we encourage:

- Testing critical functionality
- Testing security-related code
- Manual testing of all changes
- Testing on both Linux and macOS when possible

## Reporting Issues

When reporting issues, please include:

- Flutter version (`flutter --version`)
- Operating system and version
- Steps to reproduce the issue
- Expected vs. actual behavior
- Screenshots if applicable
- Relevant logs or error messages

## Questions or Help?

If you have questions or need help:

- Open an issue for discussion
- Check existing issues and pull requests
- Review the README.md for setup instructions

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the code, not the person
- Help maintain a positive community

Thank you for contributing to Password Saver!
