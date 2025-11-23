import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppDarkTheme {
  static final ThemeData themeData = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.accentColor,
      background: AppColors.darkBackground,
      surface: AppColors.darkCard,
      error: AppColors.danger,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCard,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: AppTextStyles.heading3.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      elevation: 2,
      centerTitle: true,
    ),
    iconTheme: IconThemeData(color: AppColors.accentColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentColor,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.button.copyWith(color: Colors.white), // <-- copyWith!
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accentColor,
        side: BorderSide(color: AppColors.accentColor, width: 2),
        textStyle: AppTextStyles.button.copyWith(color: AppColors.accentColor), // <-- copyWith!
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentColor,
        textStyle: AppTextStyles.button.copyWith(color: AppColors.accentColor), // <-- copyWith!
      ),
    ),
    // TEXT THEME seragam field dan copyWith
    textTheme: TextTheme(
    displayLarge: AppTextStyles.heading1.copyWith(color: Colors.white),
    displayMedium: AppTextStyles.heading2.copyWith(color: Colors.white),
    displaySmall: AppTextStyles.heading3.copyWith(color: Colors.white),
    headlineMedium: AppTextStyles.heading2.copyWith(color: Colors.white),
    titleLarge: AppTextStyles.cardTitle.copyWith(color: Colors.white),
    bodyLarge: AppTextStyles.body1.copyWith(color: Colors.white70),
    bodyMedium: AppTextStyles.body2.copyWith(color: Colors.white60),
    labelLarge: AppTextStyles.button.copyWith(color: Colors.white),
  ),

    dividerColor: AppColors.card,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      labelStyle: TextStyle(color: Colors.white70),
      prefixIconColor: AppColors.accentColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.border.withOpacity(0.35)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.accentColor, width: 1.6),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.card, width: 1.0),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    // You can add other theme configs...
  );
}
