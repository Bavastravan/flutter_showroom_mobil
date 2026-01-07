import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    // Tidak set color atau inherit, agar diatur lewat theme!
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
  );
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
  );
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.8,
    // Tidak set color/inherit: false!
  );
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final TextTheme defaultTextTheme = TextTheme(
    displayLarge: heading1,
    displayMedium: heading2,
    displaySmall: heading3,
    bodyLarge: body1,
    bodyMedium: body2,
    labelLarge: button,
    titleLarge: cardTitle,
    // Bisa ditambah field lain jika perlu.
  );
}
