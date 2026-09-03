import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color background = Color(0xFFF7F5F0);
  static const Color surface = Color(0xFFFFFEFC);
  static const Color text = Color(0xFF18212B);
  static const Color muted = Color(0xFF7C858E);
  static const Color primary = Color(0xFFE9785F);
  static const Color border = Color(0xFFE1DDD5);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        surface: surface,
        onSurface: text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: text),
        titleTextStyle: GoogleFonts.inter(
          color: text,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
      textTheme: TextTheme(
        // Use Serif for large headings
        displayLarge: GoogleFonts.playfairDisplay(
          color: text,
          fontSize: 48,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          color: text,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        // Use Sans-serif for UI elements
        titleLarge: GoogleFonts.inter(
          color: text,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.inter(
          color: text,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: text,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: text,
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.inter(
          color: muted,
          fontSize: 12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary),
        ),
        hintStyle: GoogleFonts.inter(color: muted),
      ),
      iconTheme: const IconThemeData(
        color: text,
      ),
    );
  }
}
