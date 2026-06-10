import 'package:flutter/material.dart';

class AppTheme {
  static const seed = Color(0xFF1F4E79);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
      );

  /// Cores usadas na agenda por status.
  static const statusPago = Color(0xFF2E7D32); // verde
  static const statusAguardando = Color(0xFFF9A825); // amarelo
  static const statusCancelado = Color(0xFFC62828); // vermelho
}
