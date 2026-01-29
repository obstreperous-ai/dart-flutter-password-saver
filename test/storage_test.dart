import 'package:flutter_test/flutter_test.dart';
import 'package:password_saver/storage.dart';

void main() {
  group('PasswordEntry', () {
    test('toJson serializes correctly', () {
      final entry = PasswordEntry(
        id: '123',
        title: 'Test Service',
        username: 'test@example.com',
        password: 'securePassword123',
        notes: 'Some notes',
        createdAt: DateTime(2024, 1, 1, 12, 0, 0),
        updatedAt: DateTime(2024, 1, 2, 12, 0, 0),
      );

      final json = entry.toJson();

      expect(json['id'], '123');
      expect(json['title'], 'Test Service');
      expect(json['username'], 'test@example.com');
      expect(json['password'], 'securePassword123');
      expect(json['notes'], 'Some notes');
      expect(json['createdAt'], '2024-01-01T12:00:00.000');
      expect(json['updatedAt'], '2024-01-02T12:00:00.000');
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'id': '456',
        'title': 'Another Service',
        'username': 'user@example.com',
        'password': 'password456',
        'notes': 'Important notes',
        'createdAt': '2024-02-01T10:30:00.000',
        'updatedAt': '2024-02-02T10:30:00.000',
      };

      final entry = PasswordEntry.fromJson(json);

      expect(entry.id, '456');
      expect(entry.title, 'Another Service');
      expect(entry.username, 'user@example.com');
      expect(entry.password, 'password456');
      expect(entry.notes, 'Important notes');
      expect(entry.createdAt, DateTime(2024, 2, 1, 10, 30, 0));
      expect(entry.updatedAt, DateTime(2024, 2, 2, 10, 30, 0));
    });

    test('toJson and fromJson are reversible', () {
      final original = PasswordEntry(
        id: '789',
        title: 'Reversible Test',
        username: 'reversible@example.com',
        password: 'reversePass789',
        notes: null,
        createdAt: DateTime(2024, 3, 1, 8, 15, 0),
        updatedAt: DateTime(2024, 3, 1, 8, 15, 0),
      );

      final json = original.toJson();
      final reconstructed = PasswordEntry.fromJson(json);

      expect(reconstructed.id, original.id);
      expect(reconstructed.title, original.title);
      expect(reconstructed.username, original.username);
      expect(reconstructed.password, original.password);
      expect(reconstructed.notes, original.notes);
      expect(reconstructed.createdAt, original.createdAt);
      expect(reconstructed.updatedAt, original.updatedAt);
    });

    test('handles null notes correctly', () {
      final entry = PasswordEntry(
        id: '101',
        title: 'No Notes',
        username: 'nonotes@example.com',
        password: 'password101',
        notes: null,
        createdAt: DateTime(2024, 4, 1),
        updatedAt: DateTime(2024, 4, 1),
      );

      final json = entry.toJson();
      expect(json['notes'], null);

      final reconstructed = PasswordEntry.fromJson(json);
      expect(reconstructed.notes, null);
    });
  });

  group('EncryptedPasswordStorage', () {
    test('throws exception if not initialized before savePasswords', () async {
      final storage = EncryptedPasswordStorage();
      final passwords = [
        PasswordEntry(
          id: '1',
          title: 'Test',
          username: 'user',
          password: 'pass',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      expect(
        () => storage.savePasswords(passwords),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Encryption not initialized'),
          ),
        ),
      );
    });

    test('throws exception if not initialized before loadPasswords', () async {
      final storage = EncryptedPasswordStorage();

      expect(
        storage.loadPasswords,
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Encryption not initialized'),
          ),
        ),
      );
    });
  });
}
