import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF14181C);
  static const bar = Color(0xFF0F1317);
  static const card = Color(0xFF1C232B);
  static const border = Color(0xFF2C3540);
  static const field = Color(0xFF232B34);
  static const slate = Color(0xFF556678);
  static const green = Color(0xFF00E054);
  static const blue = Color(0xFF40BCF4);
  static const orange = Color(0xFFFF8000);
  static const red = Color(0xFFFF5C5C);
  static const muted = Color(0xFF9AB0C4);
  static const dim = Color(0xFF6B7A8A);
}

class AppTheme {
  static ThemeData get dark {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border),
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.green,
        secondary: AppColors.blue,
        surface: AppColors.card,
        error: AppColors.red,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bar,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.green,
        foregroundColor: Color(0xFF06210F),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.field,
        hintStyle: const TextStyle(color: AppColors.dim),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.green),
        ),
      ),
    );
  }
}