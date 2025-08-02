import 'package:flutter/material.dart';

class AppTheme {
  // Core brand colors
  static const _primaryColor = Color(0xFF2E7D32); // Forest Green
  static const _primaryLight = Color(0xFF4CAF50); // Light Green
  static const _primaryDark = Color(0xFF1B5E20); // Dark Green
  static const _secondary = Color(0xFF66BB6A); // Fresh Green
  static const _accent = Color(0xFF8BC34A); // Lime Green
  
  // Functional colors
  static const _success = Color(0xFF4CAF50);
  static const _warning = Color(0xFFFF9800);
  static const _error = Color(0xFFf44336);
  static const _info = Color(0xFF2196F3);
  
  // Surface colors for light theme
  static const _lightSurface = Color(0xFFFAFAFA);
  static const _lightBackground = Color(0xFFFFFFFF);
  static const _lightCard = Color(0xFFFFFFFF);
  
  // Surface colors for dark theme
  static const _darkSurface = Color(0xFF121212);
  static const _darkBackground = Color(0xFF000000);
  static const _darkCard = Color(0xFF1E1E1E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: _primaryColor,
        primaryContainer: _primaryLight.withOpacity(0.1),
        secondary: _secondary,
        secondaryContainer: _secondary.withOpacity(0.1),
        tertiary: _accent,
        surface: _lightSurface,
        background: _lightBackground,
        error: _error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF1A1A1A),
        onBackground: const Color(0xFF1A1A1A),
        onError: Colors.white,
        outline: const Color(0xFFE0E0E0),
        outlineVariant: const Color(0xFFF5F5F5),
      ),
      scaffoldBackgroundColor: _lightSurface,
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackground,
        foregroundColor: _primaryColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black12,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
        iconTheme: IconThemeData(
          color: _primaryColor,
          size: 24,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: _lightCard,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[600],
          elevation: 2,
          shadowColor: _primaryColor.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: const BorderSide(color: _primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: Colors.grey[600]),
        labelStyle: const TextStyle(color: _primaryColor),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _lightBackground,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primaryColor,
        linearTrackColor: Color(0xFFE8F5E8),
        circularTrackColor: Color(0xFFE8F5E8),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _accent,
        primaryContainer: _accent.withOpacity(0.2),
        secondary: _secondary,
        secondaryContainer: _secondary.withOpacity(0.2),
        tertiary: _primaryLight,
        surface: _darkSurface,
        background: _darkBackground,
        error: _error,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
        outline: const Color(0xFF404040),
        outlineVariant: const Color(0xFF2A2A2A),
      ),
      scaffoldBackgroundColor: _darkBackground,
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkCard,
        foregroundColor: _accent,
        elevation: 0,
        scrolledUnderElevation: 4,
        shadowColor: Colors.black26,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _accent,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
        iconTheme: IconThemeData(
          color: _accent,
          size: 24,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: _darkCard,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey[800],
          disabledForegroundColor: Colors.grey[600],
          elevation: 2,
          shadowColor: _accent.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: Colors.grey[400]),
        labelStyle: const TextStyle(color: _accent),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _accent,
        foregroundColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _accent,
        linearTrackColor: Color(0xFF2A2A2A),
        circularTrackColor: Color(0xFF2A2A2A),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF404040),
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Custom color extensions for components
  static const Color successColor = _success;
  static const Color warningColor = _warning;
  static const Color errorColor = _error;
  static const Color infoColor = _info;
  static const Color plantGreen = _primaryColor;
  static const Color lightGreen = _accent;
  
  // Surface color helpers
  static Color surfaceVariant(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFF5F5F5)
        : const Color(0xFF2A2A2A);
  }
  
  static Color onSurfaceVariant(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF666666)
        : const Color(0xFFB3B3B3);
  }
} 