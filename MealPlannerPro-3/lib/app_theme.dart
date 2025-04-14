import 'package:flutter/material.dart';

class AppTheme {
  // App Colors
  static const Color primaryColor = Color(0xFF009688); // Teal
  static const Color secondaryColor = Color(0xFF4CAF50); // Green
  static const Color accentColor = Color(0xFFFF9800); // Orange
  static const Color errorColor = Color(0xFFD32F2F); // Red
  static const Color backgroundColor = Color(0xFFF5F5F5); // Light Grey
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF212121); // Dark Grey
  static const Color textSecondaryColor = Color(0xFF757575); // Medium Grey
  static const Color dividerColor = Color(0xFFBDBDBD); // Light Grey
  
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    primaryColorLight: primaryColor.withOpacity(0.3),
    primaryColorDark: Color(0xFF00796B), // Darker Teal
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    dividerColor: dividerColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: const TextStyle(color: textSecondaryColor),
      hintStyle: const TextStyle(color: Colors.grey),
      errorStyle: const TextStyle(color: errorColor),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textPrimaryColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: textSecondaryColor,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[200]!,
      disabledColor: Colors.grey[300]!,
      selectedColor: primaryColor.withOpacity(0.2),
      secondarySelectedColor: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(color: textPrimaryColor),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: Colors.grey,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2, color: primaryColor),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey[800],
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
    ),
  );
  
  // Additional utility methods
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        spreadRadius: 1,
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration roundedDecoration({
    Color color = Colors.white,
    double radius = 12,
    bool withShadow = true,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: withShadow
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }
  
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [
      Color(0xFF009688), // Teal
      Color(0xFF00796B), // Darker Teal
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
