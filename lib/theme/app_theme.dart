import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0E1114);
  static const card = Color(0xFF171C22);
  static const border = Color(0xFF232A33);
  static const green = Color(0xFF00E054);
  static const greenSoft = Color(0xFF0F2E1D);
  static const onGreen = Color(0xFF04210F);
  static const muted = Color(0xFF9AA7B4);
  static const dim = Color(0xFF66737F);
}

class AppTheme {
  static ThemeData get dark {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.green,
        onPrimary: AppColors.onGreen,
        surface: AppColors.card,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.onGreen,
        shape: CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        hintStyle: const TextStyle(color: AppColors.dim),
        prefixIconColor: AppColors.dim,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.green),
        ),
      ),
    );
  }
}