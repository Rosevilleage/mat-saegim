import 'package:flutter/material.dart';

/// 앱 테마 설정
class AppTheme {
  static const Color primaryColor = Color(0xFF4F39F6);
  static const Color textPrimary = Color(0xFF0A0A0A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      fontFamily: 'Noto Sans KR',
    );
  }
}

