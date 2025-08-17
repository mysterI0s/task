import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en', 'US')) {
    _loadLocale();
  }

  void _loadLocale() {
    final localeString = AppConfig.prefs.getString(AppConfig.localeKey);
    if (localeString != null) {
      final parts = localeString.split('_');
      if (parts.length == 2) {
        state = Locale(parts[0], parts[1]);
      }
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await AppConfig.prefs.setString(
      AppConfig.localeKey,
      '${locale.languageCode}_${locale.countryCode}',
    );
  }
}
