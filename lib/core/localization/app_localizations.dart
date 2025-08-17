import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
  ];

  final Locale locale;

  static AppLocalizations? of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  // App strings
  String get appTitle =>
      locale.languageCode == 'ar' ? 'مستكشف البيانات' : 'Data Explorer';
  String get loading =>
      locale.languageCode == 'ar' ? 'جاري التحميل...' : 'Loading...';
  String get error => locale.languageCode == 'ar' ? 'خطأ' : 'Error';
  String get retry => locale.languageCode == 'ar' ? 'إعادة المحاولة' : 'Retry';
  String get noData =>
      locale.languageCode == 'ar' ? 'لا توجد بيانات' : 'No Data';
  String get search => locale.languageCode == 'ar' ? 'بحث' : 'Search';
  String get filter => locale.languageCode == 'ar' ? 'تصفية' : 'Filter';
  String get sort => locale.languageCode == 'ar' ? 'ترتيب' : 'Sort';

  // Navigation
  String get home => locale.languageCode == 'ar' ? 'الرئيسية' : 'Home';
  String get products => locale.languageCode == 'ar' ? 'المنتجات' : 'Products';
  String get recipes => locale.languageCode == 'ar' ? 'الوصفات' : 'Recipes';
  String get settings => locale.languageCode == 'ar' ? 'الإعدادات' : 'Settings';

  // Settings
  String get theme => locale.languageCode == 'ar' ? 'السمة' : 'Theme';
  String get language => locale.languageCode == 'ar' ? 'اللغة' : 'Language';
  String get lightTheme =>
      locale.languageCode == 'ar' ? 'سمة فاتحة' : 'Light Theme';
  String get darkTheme =>
      locale.languageCode == 'ar' ? 'سمة داكنة' : 'Dark Theme';
  String get systemTheme =>
      locale.languageCode == 'ar' ? 'سمة النظام' : 'System Theme';
  String get english => locale.languageCode == 'ar' ? 'الإنجليزية' : 'English';
  String get arabic => locale.languageCode == 'ar' ? 'العربية' : 'Arabic';

  // Product details
  String get description =>
      locale.languageCode == 'ar' ? 'الوصف' : 'Description';
  String get details => locale.languageCode == 'ar' ? 'التفاصيل' : 'Details';
  String get reviews => locale.languageCode == 'ar' ? 'المراجعات' : 'Reviews';
  String get price => locale.languageCode == 'ar' ? 'السعر' : 'Price';
  String get category => locale.languageCode == 'ar' ? 'الفئة' : 'Category';
  String get brand =>
      locale.languageCode == 'ar' ? 'العلامة التجارية' : 'Brand';
  String get stock => locale.languageCode == 'ar' ? 'المخزون' : 'Stock';
  String get rating => locale.languageCode == 'ar' ? 'التقييم' : 'Rating';

  // Recipe details
  String get ingredients =>
      locale.languageCode == 'ar' ? 'المكونات' : 'Ingredients';
  String get instructions =>
      locale.languageCode == 'ar' ? 'التعليمات' : 'Instructions';
  String get cookTime =>
      locale.languageCode == 'ar' ? 'وقت الطبخ' : 'Cook Time';
  String get prepTime =>
      locale.languageCode == 'ar' ? 'وقت التحضير' : 'Prep Time';
  String get servings => locale.languageCode == 'ar' ? 'عدد الحصص' : 'Servings';
  String get difficulty =>
      locale.languageCode == 'ar' ? 'مستوى الصعوبة' : 'Difficulty';
  String get cuisine => locale.languageCode == 'ar' ? 'نوع المطبخ' : 'Cuisine';

  // Common
  String get minutes => locale.languageCode == 'ar' ? 'دقيقة' : 'minutes';
  String get inStock => locale.languageCode == 'ar' ? 'متوفر' : 'In Stock';
  String get outOfStock =>
      locale.languageCode == 'ar' ? 'غير متوفر' : 'Out of Stock';
  String get pullToRefresh =>
      locale.languageCode == 'ar' ? 'اسحب للتحديث' : 'Pull to refresh';
  String get loadMore =>
      locale.languageCode == 'ar' ? 'تحميل المزيد' : 'Load more';
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
