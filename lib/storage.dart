import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class PasswordEntry {
  final String id;
  final String title;
  final String username;
  final String password;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PasswordEntry({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'username': username,
        'password': password,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory PasswordEntry.fromJson(Map<String, dynamic> json) =>
      PasswordEntry(
        id: json['id'] as String,
        title: json['title'] as String,
        username: json['username'] as String,
        password: json['password'] as String,
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

class EncryptedPasswordStorage {
  static const String _keyName = 'encryption_key';
  static const String _ivName = 'encryption_iv';
  static const String _fileName = 'passwords.enc';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Key? _key;
  IV? _iv;
  Encrypter? _encrypter;

  /// Initialize the encryption system
  Future<void> initialize() async {
    // Try to load existing key and IV from secure storage
    final keyString = await _secureStorage.read(key: _keyName);
    final ivString = await _secureStorage.read(key: _ivName);

    if (keyString == null || ivString == null) {
      // Generate new key and IV
      _key = Key.fromSecureRandom(32);
      _iv = IV.fromSecureRandom(16);

      // Store them in secure storage
      await _secureStorage.write(key: _keyName, value: _key!.base64);
      await _secureStorage.write(key: _ivName, value: _iv!.base64);
    } else {
      // Use existing key and IV
      _key = Key.fromBase64(keyString);
      _iv = IV.fromBase64(ivString);
    }

    _encrypter = Encrypter(AES(_key!));
  }

  /// Encrypt and save password entries
  Future<void> savePasswords(List<PasswordEntry> passwords) async {
    if (_encrypter == null) {
      throw Exception('Encryption not initialized. Call initialize() first.');
    }

    // Convert passwords to JSON
    final jsonData = jsonEncode(
      passwords.map((p) => p.toJson()).toList(),
    );

    // Encrypt the data
    final encrypted = _encrypter!.encrypt(jsonData, iv: _iv!);

    // Get the app's document directory
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_fileName');

    // Write encrypted data to file
    await file.writeAsString(encrypted.base64);
  }

  /// Load and decrypt password entries
  Future<List<PasswordEntry>> loadPasswords() async {
    if (_encrypter == null) {
      throw Exception('Encryption not initialized. Call initialize() first.');
    }

    try {
      // Get the app's document directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');

      // Check if file exists
      if (!await file.exists()) {
        return [];
      }

      // Read encrypted data
      final encryptedData = await file.readAsString();
      final encrypted = Encrypted.fromBase64(encryptedData);

      // Decrypt the data
      final decrypted = _encrypter!.decrypt(encrypted, iv: _iv!);

      // Parse JSON
      final List<dynamic> jsonData = jsonDecode(decrypted);
      return jsonData
          .map((json) => PasswordEntry.fromJson(json))
          .toList();
    } catch (e) {
      // If there's an error reading or decrypting, return empty list
      return [];
    }
  }

  /// Clear all stored data and encryption keys
  Future<void> clearAll() async {
    // Delete the encrypted file
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignore errors
    }

    // Delete encryption keys
    await _secureStorage.delete(key: _keyName);
    await _secureStorage.delete(key: _ivName);

    // Reset local variables
    _key = null;
    _iv = null;
    _encrypter = null;
  }
}
