import 'package:flutter/material.dart';
import 'ui/home_page.dart';

void main() {
  runApp(const PasswordSaverApp());
}

class PasswordSaverApp extends StatelessWidget {
  const PasswordSaverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Saver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
