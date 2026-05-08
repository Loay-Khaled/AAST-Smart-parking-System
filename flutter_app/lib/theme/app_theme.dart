import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF10B981);
  static const Color background = Color(0xFFF8FAFB);
  static const Color card = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF1A1F36);
  static const Color muted = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color available = Color(0xFF10B981);
  static const Color occupied = Color(0xFFEF4444);
  static const Color reserved = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.card,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        cardTheme: CardThemeData(
          color: AppColors.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: AppColors.primary),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.card,
          foregroundColor: AppColors.foreground,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      );
}
