import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// AppTheme is a class with only static members — meaning you never create
// an instance of it. You just call AppTheme.darkGreen or AppTheme.lightTheme.
// This is called a "utility class" pattern.

class AppTheme {
  AppTheme._(); // Private constructor — prevents anyone from doing AppTheme()

  // ── Color Palette ──────────────────────────────────────────────────────────
  // These are extracted directly from the UI design inspiration.

  // Updated to closely match the original UI design
  static const Color darkGreen = Color(0xFF0F3122);     // Rich dark forest green (card & nav bg)
  static const Color mediumGreen = Color(0xFF1B4230);   // Slightly lighter dark green (inactive buttons/nav)
  static const Color cardGreen = Color(0xFF0F3122);     // Balance card background (dark green)
  static const Color accentGreen = Color(0xFFD8FA3C);   // Neon lime/yellow for highlights/charts
  static const Color actionYellow = Color(0xFFD8FA3C);  // Active buttons (neon yellow/lime)
  static const Color textLight = Color(0xFFFFFFFF);     // White text on dark green surfaces
  static const Color textDark = Color(0xFF0F3122);      // Dark forest green text on light surfaces
  static const Color textMuted = Color(0xFF708779);     // Muted greyish-green for subtitles/dates
  static const Color pageBg = Color(0xFF051A1A);        // Very dark teal page background
  static const Color receivedGreen = Color(0xFF2ECC71); // Positive amount status color
  static const Color sentRed = Color(0xFFE74C3C);       // Negative amount status color
  static const Color cardWhite = Color(0xFFFFFFFF);     // Transaction card bg
  static const Color iconBg = Color(0xFFEEF3EE);        // Icon background circle

  // ── Typography ─────────────────────────────────────────────────────────────
  // We use GoogleFonts.inter() so the font is consistent everywhere.
  // By defining styles here, widgets just call AppTheme.headingStyle
  // instead of repeating TextStyle(...) in every file.

  static TextStyle get headingLarge => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textDark,
      );

  static TextStyle get headingMedium => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textDark,
      );

  static TextStyle get balanceAmount => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: textLight,
        letterSpacing: -0.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textDark,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMuted,
      );

  static TextStyle get labelBold => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textDark,
      );

  // ── ThemeData ──────────────────────────────────────────────────────────────
  // This is what we pass to MaterialApp(theme: ...).
  // Flutter uses this to style all its built-in widgets (AppBar, etc.)

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: darkGreen,
      onPrimary: textLight,
      secondary: accentGreen,
      onSecondary: darkGreen,
      surface: mediumGreen,
      onSurface: textLight,
      background: pageBg,
      onBackground: textLight,
      error: sentRed,
      onError: textLight,
      primaryContainer: cardGreen,
      secondaryContainer: iconBg,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: pageBg,
      colorScheme: colorScheme,
      primaryColor: darkGreen,
      cardColor: mediumGreen,
      dialogBackgroundColor: mediumGreen,
      dividerColor: iconBg.withOpacity(0.35),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkGreen,
        foregroundColor: textLight,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: mediumGreen,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: iconBg.withOpacity(0.18)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: iconBg.withOpacity(0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: accentGreen.withOpacity(0.8), width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: textLight.withOpacity(0.9), fontWeight: FontWeight.w500),
        hintStyle: GoogleFonts.inter(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGreen,
          foregroundColor: darkGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textLight,
          side: BorderSide(color: iconBg.withOpacity(0.28)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textLight,
        displayColor: textLight,
      ),
      // Remove splash/ripple effect on taps
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
    );
  }
}
