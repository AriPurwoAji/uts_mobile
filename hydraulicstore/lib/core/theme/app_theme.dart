import 'package:flutter/material.dart';

class AppTheme {
  // Warna utama Hydrau-Link (sesuai desain mockup)
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color darkNavy     = Color(0xFF1A2B4A);
  static const Color lightGrey    = Color(0xFFF5F5F5);
  static const Color white        = Color(0xFFFFFFFF);
  static const Color starYellow   = Color(0xFFFFC107);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryOrange,
      primary: primaryOrange,
      onPrimary: white,
      secondary: darkNavy,
      surface: white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: white,
      foregroundColor: darkNavy,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: darkNavy,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
        foregroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryOrange, width: 2),
      ),
    ),
  );
}