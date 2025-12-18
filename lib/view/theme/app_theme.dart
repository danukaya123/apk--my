import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Modern color palette from the image
  static const Color primary = Color(0xFF00FF7F); // Vibrant Green
  static const Color backgroundDark = Color(0xFF212327); // Dark background
  static const Color surfaceDark = Color(0xFF2C2F33); // Slightly lighter dark
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundDark,
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme)
        .copyWith(
          displayLarge: GoogleFonts.oswald(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.oswald(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: GoogleFonts.oswald(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: GoogleFonts.oswald(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: GoogleFonts.oswald(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.oswald(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: GoogleFonts.poppins(color: textPrimary, fontSize: 16),
          bodyMedium: GoogleFonts.poppins(color: textSecondary, fontSize: 14),
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: primary),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: backgroundDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDark,
      hintStyle: GoogleFonts.poppins(color: textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
      linearTrackColor: surfaceDark,
      circularTrackColor: surfaceDark,
    ),
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primary,
      unselectedItemColor: textSecondary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: backgroundDark,
    ),
  );

  static final ThemeData lightTheme = ThemeData.light();
}
