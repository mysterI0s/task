import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static const String baseUrl = 'https://dummyjson.com';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Cache
  static const Duration cacheExpiration = Duration(hours: 1);
  static const String cacheKey = 'app_cache';

  // Storage keys
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String onboardingKey = 'onboarding_completed';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs => _prefs;

  // Environment-specific configurations
  static bool get isDebug =>
      const bool.fromEnvironment('dart.vm.product') == false;
  static String get apiKey => const String.fromEnvironment('API_KEY');
}
