import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: BarberApp()));
}

class BarberApp extends StatelessWidget {
  const BarberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarberApp',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(child: Text('BarberApp — estrutura inicial')),
      ),
    );
  }
}
