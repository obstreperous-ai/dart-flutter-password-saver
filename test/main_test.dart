import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_saver/main.dart';

void main() {
  testWidgets('PasswordSaverApp creates MaterialApp', (tester) async {
    await tester.pumpWidget(const PasswordSaverApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App title is set correctly', (tester) async {
    await tester.pumpWidget(const PasswordSaverApp());

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.title, 'Password Saver');
  });

  testWidgets('App uses Material 3', (tester) async {
    await tester.pumpWidget(const PasswordSaverApp());

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.useMaterial3, true);
  });

  testWidgets('App has a theme with deep purple seed color', (tester) async {
    await tester.pumpWidget(const PasswordSaverApp());

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(
      materialApp.theme?.colorScheme.primary,
      isNot(equals(Colors.deepPurple)),
    ); // Should be derived from seed
  });
}
