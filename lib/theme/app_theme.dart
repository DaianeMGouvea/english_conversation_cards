import 'package:flutter/material.dart';

class AppTheme {
  // Card category colors
  static const Color greenCard = Color(0xFF4CAF50);
  static const Color blueCard = Color(0xFF2196F3);
  static const Color orangeCard = Color(0xFFFF9800);

  // Light theme colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Colors.white;
  static const Color onSurfaceLight = Color(0xFF1A1A1A);

  // Dark theme colors  
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color onSurfaceDark = Color(0xFFE0E0E0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: blueCard,
        secondary: greenCard,
        tertiary: orangeCard,
        surface: surfaceLight,
        onSurface: onSurfaceLight,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: CircleBorder(),
      ),
      tabBarTheme: const TabBarThemeData(
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: blueCard, width: 2),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: blueCard,
        secondary: greenCard,
        tertiary: orangeCard,
        surface: surfaceDark,
        onSurface: onSurfaceDark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: CircleBorder(),
      ),
      tabBarTheme: const TabBarThemeData(
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: blueCard, width: 2),
        ),
      ),
    );
  }

  static Color getCategoryColor(int categoryIndex) {
    switch (categoryIndex) {
      case 0:
        return greenCard;
      case 1:
        return blueCard;
      case 2:
        return orangeCard;
      default:
        return blueCard;
    }
  }
}
