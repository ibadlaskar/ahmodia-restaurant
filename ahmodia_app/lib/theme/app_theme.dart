// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const green      = Color(0xFF1B4332);
  static const green2     = Color(0xFF2D6A4F);
  static const green3     = Color(0xFF40916C);
  static const greenLight = Color(0xFFD8F3DC);
  static const saffron    = Color(0xFFD4820A);
  static const saffron2   = Color(0xFFF0A500);
  static const saffronLight = Color(0xFFFFF8E1);
  static const cream      = Color(0xFFFBF7F0);
  static const cream2     = Color(0xFFF5EEE1);
  static const cream3     = Color(0xFFEDE3D0);
  static const dark       = Color(0xFF1A1208);
  static const mid        = Color(0xFF3D2B1F);
  static const gray       = Color(0xFF7A6A5A);
  static const lgray      = Color(0xFFC8B8A2);
  static const xlgray     = Color(0xFFF0E8DC);
  static const white      = Color(0xFFFFFFFF);
  static const red        = Color(0xFFC0392B);
  static const blue       = Color(0xFF2563EB);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.green,
      primary: AppColors.green,
      secondary: AppColors.saffron,
      surface: AppColors.white,
      background: AppColors.cream,
    ),
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.dark),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.dark),
      headlineMedium: GoogleFonts.nunito(
        fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.dark),
      titleLarge: GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.dark),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.mid),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.gray),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.green,
      foregroundColor: AppColors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.cream3, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.cream3, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.green3, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.nunito(color: AppColors.lgray),
      labelStyle: GoogleFonts.nunito(fontWeight: FontWeight.w700, color: AppColors.mid),
    ),
    cardTheme: CardTheme(
      color: AppColors.white,
      elevation: 2,
      shadowColor: AppColors.green.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cream3, width: 1.5),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.green,
      unselectedItemColor: AppColors.lgray,
      type: BottomNavigationBarType.fixed,
      elevation: 12,
    ),
  );
}
