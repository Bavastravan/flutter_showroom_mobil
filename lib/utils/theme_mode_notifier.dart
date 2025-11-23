
import 'package:flutter/material.dart';

class ThemeModeNotifier extends ValueNotifier<ThemeMode> {
  ThemeModeNotifier([ThemeMode initial = ThemeMode.system]) : super(initial);

  void toggleMode() {
    value = value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
