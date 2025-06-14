import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primary = Color(0xFF000000); // Black for primary elements
  static const Color secondary = Color(0xFF1A1A1A); // Dark gray for secondary elements
  static const Color accent = Color(0xFF333333); // Slightly lighter gray for accents
  static const Color background = Color(0xFFFFFFFF); // White background
  static const Color surface = Color(0xFFFFFFFF); // White surface
  static const Color error = Color(0xFFD32F2F); // Keep red for errors
  static const Color success = Color(0xFF2E7D32); // Keep green for success
  static const Color warning = Color(0xFFF57C00); // Keep orange for warnings
  static const Color info = Color(0xFF1976D2); // Keep blue for info
  static const Color text = Color(0xFF000000); // Black text
  static const Color textPrimary = text;
  static const Color textSecondary = Color(0xFF666666); // Dark gray for secondary text
  static const Color divider = Color(0xFFE0E0E0); // Light gray for dividers
  static const Color border = divider;
  static const Color backgroundSecondary = Color(0xFFF5F5F5); // Light gray for secondary background

  // Text Styles
  static TextStyle get heading1 => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: text,
      );

  static TextStyle get heading2 => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: text,
      );

  static TextStyle get heading3 => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: text,
      );

  static TextStyle get body1 => GoogleFonts.poppins(
        fontSize: 16,
        color: text,
      );

  static TextStyle get body2 => GoogleFonts.poppins(
        fontSize: 14,
        color: textSecondary,
      );

  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: surface, // White text on black button
      );

  static TextStyle get headingStyle => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: text,
      );

  static TextStyle get bodyStyle => GoogleFonts.poppins(
        fontSize: 16,
        color: text,
      );

  static TextStyle get captionStyle => GoogleFonts.poppins(
        fontSize: 12,
        color: textSecondary,
      );

  static TextStyle get buttonStyle => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: surface, // White text on black button
      );

  // Theme Data
  static ThemeData get lightTheme => ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.light(
          primary: primary,
          secondary: secondary,
          surface: surface,
          background: background,
          error: error,
        ),
        textTheme: TextTheme(
          displayLarge: heading1,
          displayMedium: heading2,
          displaySmall: heading3,
          bodyLarge: body1,
          bodyMedium: body2,
          labelLarge: button,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: surface,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: heading3,
          iconTheme: const IconThemeData(color: text),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary, // Black button
            foregroundColor: surface, // White text
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: error),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        cardTheme: CardTheme(
          color: surface,
          elevation: 0, // Remove elevation for flat design
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: divider), // Add subtle border
          ),
        ),
      );
} 