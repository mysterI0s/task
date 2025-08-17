import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/core/localization/app_localizations.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.settings ?? 'Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          _buildSection(
            context,
            title: AppLocalizations.of(context)?.theme ?? 'Appearance',
            icon: Icons.palette_outlined,
            children: [
              _buildThemeOption(
                context,
                ref,
                title:
                    AppLocalizations.of(context)?.lightTheme ?? 'Light Theme',
                subtitle: 'Use light colors',
                value: AppThemeMode.light,
                groupValue: appThemeMode,
                icon: Icons.light_mode_outlined,
              ),
              _buildThemeOption(
                context,
                ref,
                title: AppLocalizations.of(context)?.darkTheme ?? 'Dark Theme',
                subtitle: 'Use dark colors',
                value: AppThemeMode.dark,
                groupValue: appThemeMode,
                icon: Icons.dark_mode_outlined,
              ),
              _buildThemeOption(
                context,
                ref,
                title:
                    AppLocalizations.of(context)?.systemTheme ?? 'System Theme',
                subtitle: 'Follow system settings',
                value: AppThemeMode.system,
                groupValue: appThemeMode,
                icon: Icons.settings_suggest_outlined,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Language Section
          _buildSection(
            context,
            title: AppLocalizations.of(context)?.language ?? 'Language',
            icon: Icons.language_outlined,
            children: [
              _buildLanguageOption(
                context,
                ref,
                title: AppLocalizations.of(context)?.english ?? 'English',
                subtitle: 'English (US)',
                value: const Locale('en', 'US'),
                groupValue: locale,
                flag: '🇺🇸',
              ),
              _buildLanguageOption(
                context,
                ref,
                title: AppLocalizations.of(context)?.arabic ?? 'العربية',
                subtitle: 'Arabic (Saudi Arabia)',
                value: const Locale('ar', 'SA'),
                groupValue: locale,
                flag: '🇸🇦',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // About Section
          _buildSection(
            context,
            title: AppLocalizations.of(context)?.about ?? 'About',
            icon: Icons.info_outline,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.analytics_rounded,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)?.appTitle ?? 'Data Explorer',
                ),
                subtitle: Text(
                  '${AppLocalizations.of(context)?.version ?? 'Version'} 1.0.0',
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () => _showAboutDialog(context),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer,
                  child: Icon(
                    Icons.privacy_tip_outlined,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)?.privacyPolicyTitle ??
                      'Privacy Policy',
                ),
                subtitle: Text(
                  AppLocalizations.of(context)?.howWeProtectData ??
                      'How we protect your data',
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () => _showPrivacyPolicy(context),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.tertiaryContainer,
                  child: Icon(
                    Icons.article_outlined,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)?.termsOfServiceTitle ??
                      'Terms of Service',
                ),
                subtitle: Text(
                  AppLocalizations.of(context)?.termsAndConditions ??
                      'Terms and conditions',
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () => _showTermsOfService(context),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Support Section
          _buildSection(
            context,
            title: AppLocalizations.of(context)?.support ?? 'Support',
            icon: Icons.support_outlined,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.feedback_outlined,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)?.sendFeedbackTitle ??
                      'Send Feedback',
                ),
                subtitle: Text(
                  AppLocalizations.of(context)?.helpUsImprove ??
                      'Help us improve the app',
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () => _showFeedbackDialog(context),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer,
                  child: Icon(
                    Icons.star_outline,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)?.rateApp ?? 'Rate App',
                ),
                subtitle: Text(
                  AppLocalizations.of(context)?.rateUsOnAppStore ??
                      'Rate us on the app store',
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () => _showRateAppDialog(context),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      Card(
        margin: EdgeInsets.zero,
        child: Column(children: children),
      ),
    ],
  );

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String subtitle,
    required AppThemeMode value,
    required AppThemeMode groupValue,
    required IconData icon,
  }) {
    final isSelected = value == groupValue;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          icon,
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Radio<AppThemeMode>(
        value: value,
        groupValue: groupValue,
        onChanged: (AppThemeMode? newValue) {
          if (newValue != null) {
            ref.read(appThemeModeProvider.notifier).setTheme(newValue);
            // Also update the actual theme mode
            ref
                .read(themeModeProvider.notifier)
                .setTheme(ref.read(appThemeModeProvider.notifier).themeMode);
          }
        },
      ),
      onTap: () {
        ref.read(appThemeModeProvider.notifier).setTheme(value);
        ref
            .read(themeModeProvider.notifier)
            .setTheme(ref.read(appThemeModeProvider.notifier).themeMode);
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String subtitle,
    required Locale value,
    required Locale groupValue,
    required String flag,
  }) {
    final isSelected = value == groupValue;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Text(flag, style: const TextStyle(fontSize: 20)),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Radio<Locale>(
        value: value,
        groupValue: groupValue,
        onChanged: (Locale? newValue) {
          if (newValue != null) {
            ref.read(localeProvider.notifier).setLocale(newValue);
          }
        },
      ),
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(value);
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName:
          AppLocalizations.of(context)?.appTitle ?? 'Data Explorer',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.analytics_rounded,
          size: 32,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      children: [
        Text(
          AppLocalizations.of(context)?.appDescription ??
              'A modern Flutter application for exploring and discovering data from various sources. '
                  'Built with clean architecture, Material 3 design, and best practices.',
        ),
      ],
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)?.privacyPolicyTitle ?? 'Privacy Policy',
        ),
        content: SingleChildScrollView(
          child: Text(
            AppLocalizations.of(context)?.privacyPolicyContent ??
                'This app respects your privacy. We do not collect, store, or share any personal information. '
                    'All data displayed in the app is fetched from public APIs and is not stored on our servers.\n\n'
                    'The app may store user preferences locally on your device for a better user experience.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)?.close ?? 'Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)?.termsOfServiceTitle ??
              'Terms of Service',
        ),
        content: SingleChildScrollView(
          child: Text(
            AppLocalizations.of(context)?.termsOfServiceContent ??
                'By using this app, you agree to the following terms:\n\n'
                    '1. This app is provided "as is" without any warranties.\n'
                    '2. The data displayed is fetched from third-party APIs and we are not responsible for its accuracy.\n'
                    '3. Use this app responsibly and in accordance with applicable laws.\n'
                    '4. We reserve the right to update these terms at any time.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)?.close ?? 'Close'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)?.sendFeedbackTitle ?? 'Send Feedback',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)?.sendFeedbackContent ??
                  'We value your feedback! Let us know how we can improve.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    AppLocalizations.of(context)?.enterFeedbackHint ??
                    'Enter your feedback here...',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)?.thankYouFeedback ??
                        'Thank you for your feedback!',
                  ),
                ),
              );
            },
            child: Text(AppLocalizations.of(context)?.send ?? 'Send'),
          ),
        ],
      ),
    );
  }

  void _showRateAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)?.rateAppTitle ?? 'Rate Data Explorer',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)?.rateAppContent ??
                  'Enjoying the app? Please consider rating us!',
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)?.maybeLater ?? 'Maybe Later',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)?.thankYouRateApp ??
                        'Thank you! Redirecting to app store...',
                  ),
                ),
              );
            },
            child: Text(AppLocalizations.of(context)?.rateNow ?? 'Rate Now'),
          ),
        ],
      ),
    );
  }
}
