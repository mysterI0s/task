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

  // Settings and dialogs
  String get close => locale.languageCode == 'ar' ? 'إغلاق' : 'Close';
  String get cancel => locale.languageCode == 'ar' ? 'إلغاء' : 'Cancel';
  String get send => locale.languageCode == 'ar' ? 'إرسال' : 'Send';
  String get maybeLater =>
      locale.languageCode == 'ar' ? 'ربما لاحقاً' : 'Maybe Later';
  String get rateNow => locale.languageCode == 'ar' ? 'قيّم الآن' : 'Rate Now';

  // App description
  String get appDescription => locale.languageCode == 'ar'
      ? 'تطبيق Flutter حديث لاستكشاف واكتشاف البيانات من مصادر مختلفة. مبني بهندسة نظيفة وتصميم Material 3 وأفضل الممارسات.'
      : 'A modern Flutter application for exploring and discovering data from various sources. Built with clean architecture, Material 3 design, and best practices.';

  // Privacy Policy
  String get privacyPolicyTitle =>
      locale.languageCode == 'ar' ? 'سياسة الخصوصية' : 'Privacy Policy';
  String get privacyPolicyContent => locale.languageCode == 'ar'
      ? 'هذا التطبيق يحترم خصوصيتك. نحن لا نجمع أو نخزن أو نشارك أي معلومات شخصية. جميع البيانات المعروضة في التطبيق يتم جلبها من واجهات برمجة التطبيقات العامة ولا يتم تخزينها على خوادمنا.\n\nقد يقوم التطبيق بتخزين تفضيلات المستخدم محلياً على جهازك لتجربة مستخدم أفضل.'
      : 'This app respects your privacy. We do not collect, store, or share any personal information. All data displayed in the app is fetched from public APIs and is not stored on our servers.\n\nThe app may store user preferences locally on your device for a better user experience.';

  // Terms of Service
  String get termsOfServiceTitle =>
      locale.languageCode == 'ar' ? 'شروط الخدمة' : 'Terms of Service';
  String get termsOfServiceContent => locale.languageCode == 'ar'
      ? 'باستخدام هذا التطبيق، فإنك توافق على الشروط التالية:\n\n1. يتم توفير هذا التطبيق "كما هو" دون أي ضمانات.\n2. البيانات المعروضة يتم جلبها من واجهات برمجة التطبيقات الخارجية ونحن لسنا مسؤولين عن دقتها.\n3. استخدم هذا التطبيق بمسؤولية ووفقاً للقوانين المعمول بها.\n4. نحتفظ بالحق في تحديث هذه الشروط في أي وقت.'
      : 'By using this app, you agree to the following terms:\n\n1. This app is provided "as is" without any warranties.\n2. The data displayed is fetched from third-party APIs and we are not responsible for its accuracy.\n3. Use this app responsibly and in accordance with applicable laws.\n4. We reserve the right to update these terms at any time.';

  // Feedback
  String get sendFeedbackTitle =>
      locale.languageCode == 'ar' ? 'إرسال تعليق' : 'Send Feedback';
  String get sendFeedbackContent => locale.languageCode == 'ar'
      ? 'نحن نقدر تعليقك! أخبرنا كيف يمكننا التحسين.'
      : 'We value your feedback! Let us know how we can improve.';
  String get enterFeedbackHint => locale.languageCode == 'ar'
      ? 'أدخل تعليقك هنا...'
      : 'Enter your feedback here...';
  String get thankYouFeedback => locale.languageCode == 'ar'
      ? 'شكراً لك على تعليقك!'
      : 'Thank you for your feedback!';

  // Rate App
  String get rateAppTitle => locale.languageCode == 'ar'
      ? 'قيّم مستكشف البيانات'
      : 'Rate Data Explorer';
  String get rateAppContent => locale.languageCode == 'ar'
      ? 'تستمتع بالتطبيق؟ يرجى النظر في تقييمنا!'
      : 'Enjoying the app? Please consider rating us!';
  String get thankYouRateApp => locale.languageCode == 'ar'
      ? 'شكراً لك! إعادة توجيه إلى متجر التطبيقات...'
      : 'Thank you! Redirecting to app store...';

  // Additional settings strings
  String get about => locale.languageCode == 'ar' ? 'حول' : 'About';
  String get support => locale.languageCode == 'ar' ? 'الدعم' : 'Support';
  String get rateApp =>
      locale.languageCode == 'ar' ? 'قيّم التطبيق' : 'Rate App';
  String get helpUsImprove => locale.languageCode == 'ar'
      ? 'ساعدنا في التحسين'
      : 'Help us improve the app';
  String get rateUsOnAppStore => locale.languageCode == 'ar'
      ? 'قيّمنا على متجر التطبيقات'
      : 'Rate us on the app store';
  String get howWeProtectData => locale.languageCode == 'ar'
      ? 'كيف نحمي بياناتك'
      : 'How we protect your data';
  String get termsAndConditions =>
      locale.languageCode == 'ar' ? 'الشروط والأحكام' : 'Terms and conditions';
  String get version => locale.languageCode == 'ar' ? 'الإصدار' : 'Version';

  // Additional product strings
  String get unknownBrand =>
      locale.languageCode == 'ar' ? 'علامة تجارية غير معروفة' : 'Unknown Brand';
  String get returnPolicy =>
      locale.languageCode == 'ar' ? 'سياسة الإرجاع' : 'Return Policy';
  String get minimumOrder =>
      locale.languageCode == 'ar' ? 'الحد الأدنى للطلب' : 'Minimum Order';
  String get units => locale.languageCode == 'ar' ? 'وحدات' : 'units';
  String get tryAgain =>
      locale.languageCode == 'ar' ? 'حاول مرة أخرى' : 'Try Again';
  String get goHome =>
      locale.languageCode == 'ar' ? 'اذهب للرئيسية' : 'Go Home';
  String get clearAll => locale.languageCode == 'ar' ? 'مسح الكل' : 'Clear All';
  String get sortBy => locale.languageCode == 'ar' ? 'ترتيب حسب' : 'Sort By';
  String get connectionTimeout =>
      locale.languageCode == 'ar' ? 'انتهت مهلة الاتصال' : 'Connection timeout';
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
