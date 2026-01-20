import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_saver/ui/home_page.dart';
import 'package:password_saver/storage.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('HomePage displays app bar with correct title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      expect(find.text('Password Saver'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('HomePage shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Before pumpAndSettle, should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('HomePage shows search field after loading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Search'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('HomePage shows empty state when no passwords', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      expect(find.text('No passwords saved yet'), findsOneWidget);
    });

    testWidgets('HomePage has floating action button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  group('PasswordListItem Widget Tests', () {
    testWidgets('PasswordListItem displays entry information', (tester) async {
      final entry = PasswordEntry(
        id: '1',
        title: 'Test Service',
        username: 'test@example.com',
        password: 'password123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordListItem(
              entry: entry,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Service'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('PasswordListItem shows first letter in avatar', (tester) async {
      final entry = PasswordEntry(
        id: '1',
        title: 'GitHub',
        username: 'user@example.com',
        password: 'pass',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordListItem(
              entry: entry,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('G'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('PasswordListItem calls onTap when tapped', (tester) async {
      var tapped = false;
      final entry = PasswordEntry(
        id: '1',
        title: 'Test',
        username: 'user',
        password: 'pass',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordListItem(
              entry: entry,
              onTap: () {
                tapped = true;
              },
              onDelete: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });

    testWidgets('PasswordListItem calls onDelete when delete tapped', (tester) async {
      var deleted = false;
      final entry = PasswordEntry(
        id: '1',
        title: 'Test',
        username: 'user',
        password: 'pass',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordListItem(
              entry: entry,
              onTap: () {},
              onDelete: () {
                deleted = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(deleted, true);
    });
  });

  group('PasswordEditPage Widget Tests', () {
    testWidgets('PasswordEditPage shows "Add Password" for new entry', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordEditPage(),
        ),
      );

      expect(find.text('Add Password'), findsOneWidget);
    });

    testWidgets('PasswordEditPage shows "Edit Password" for existing entry', (tester) async {
      final entry = PasswordEntry(
        id: '1',
        title: 'Test',
        username: 'user',
        password: 'pass',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: PasswordEditPage(entry: entry),
        ),
      );

      expect(find.text('Edit Password'), findsOneWidget);
    });

    testWidgets('PasswordEditPage has all required text fields', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordEditPage(),
        ),
      );

      expect(find.widgetWithText(TextFormField, 'Title'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Username/Email'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Notes (optional)'),
        findsOneWidget,
      );
    });

    testWidgets('PasswordEditPage password field is obscured', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordEditPage(),
        ),
      );

      // Find the TextField widget inside TextFormField
      final textField = tester.widget<TextField>(
        find.descendant(
          of: find.widgetWithText(TextFormField, 'Password'),
          matching: find.byType(TextField),
        ),
      );
      expect(textField.obscureText, true);
    });

    testWidgets('PasswordEditPage has visibility toggle button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordEditPage(),
        ),
      );

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('PasswordEditPage has copy button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordEditPage(),
        ),
      );

      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets('PasswordEditPage has save button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordEditPage(),
        ),
      );

      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('PasswordEditPage pre-fills fields for existing entry', (tester) async {
      final entry = PasswordEntry(
        id: '1',
        title: 'GitHub',
        username: 'user@github.com',
        password: 'secret123',
        notes: 'My GitHub account',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: PasswordEditPage(entry: entry),
        ),
      );

      expect(find.text('GitHub'), findsOneWidget);
      expect(find.text('user@github.com'), findsOneWidget);
      expect(find.text('secret123'), findsOneWidget);
      expect(find.text('My GitHub account'), findsOneWidget);
    });

    testWidgets('PasswordEditPage toggles password visibility', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordEditPage(),
        ),
      );

      // Initially obscured - find the TextField widget inside TextFormField
      var textField = tester.widget<TextField>(
        find.descendant(
          of: find.widgetWithText(TextFormField, 'Password'),
          matching: find.byType(TextField),
        ),
      );
      expect(textField.obscureText, true);

      // Tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      // Should now be visible
      textField = tester.widget<TextField>(
        find.descendant(
          of: find.widgetWithText(TextFormField, 'Password'),
          matching: find.byType(TextField),
        ),
      );
      expect(textField.obscureText, false);

      // Icon should change
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });
}
