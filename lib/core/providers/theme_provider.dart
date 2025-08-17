import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';

enum AppThemeMode { light, dark, system }

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

final appThemeModeProvider =
    StateNotifierProvider<AppThemeModeNotifier, AppThemeMode>(
      (ref) => AppThemeModeNotifier(),
    );

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeIndex = AppConfig.prefs.getInt(AppConfig.themeKey) ?? 2;
    state = ThemeMode.values[themeIndex];
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    state = themeMode;
    await AppConfig.prefs.setInt(AppConfig.themeKey, themeMode.index);
  }
}

class AppThemeModeNotifier extends StateNotifier<AppThemeMode> {
  AppThemeModeNotifier() : super(AppThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeString = AppConfig.prefs.getString('app_theme_mode') ?? 'system';
    state = AppThemeMode.values.firstWhere(
      (mode) => mode.name == themeString,
      orElse: () => AppThemeMode.system,
    );
  }

  Future<void> setTheme(AppThemeMode themeMode) async {
    state = themeMode;
    await AppConfig.prefs.setString('app_theme_mode', themeMode.name);
  }

  ThemeMode get themeMode {
    switch (state) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
