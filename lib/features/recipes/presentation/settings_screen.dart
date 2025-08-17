import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          _buildSection(
            context,
            title: 'Appearance',
            icon: Icons.palette_outlined,
            children: [
              _buildThemeOption(
                context,
                ref,
                title: 'Light Theme',
                subtitle: 'Use light colors',
                value: AppThemeMode.light,
                groupValue: appThemeMode,
                icon: Icons.light_mode_outlined,
              ),
              _buildThemeOption(
                context,
                ref,
                title: 'Dark Theme',
                subtitle: 'Use dark colors',
                value: AppThemeMode.dark,
                groupValue: appThemeMode,
                icon: Icons.dark_mode_outlined,
              ),
              _buildThemeOption(
                context,
                ref,
                title: 'System Theme',
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
            title: 'Language',
            icon: Icons.language_outlined,
            children: [
              _buildLanguageOption(
                context,
                ref,
                title: 'English',
                subtitle: 'English (US)',
                value: const Locale('en', 'US'),
                groupValue: locale,
                flag: '🇺🇸',
              ),
              _buildLanguageOption(
                context,
                ref,
                title: 'العربية',
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
            title: 'About',
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
                title: const Text('Data Explorer'),
                subtitle: const Text('Version 1.0.0'),
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
                title: const Text('Privacy Policy'),
                subtitle: const Text('How we protect your data'),
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
                title: const Text('Terms of Service'),
                subtitle: const Text('Terms and conditions'),
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
            title: 'Support',
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
                title: const Text('Send Feedback'),
                subtitle: const Text('Help us improve the app'),
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
                title: const Text('Rate App'),
                subtitle: const Text('Rate us on the app store'),
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
      applicationName: 'Data Explorer',
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
        const Text(
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
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'This app respects your privacy. We do not collect, store, or share any personal information. '
            'All data displayed in the app is fetched from public APIs and is not stored on our servers.\n\n'
            'The app may store user preferences locally on your device for a better user experience.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
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
            child: const Text('Close'),
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
        title: const Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'We value your feedback! Let us know how we can improve.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter your feedback here...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your feedback!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showRateAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate Data Explorer'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enjoying the app? Please consider rating us!'),
            SizedBox(height: 16),
            Row(
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
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you! Redirecting to app store...'),
                ),
              );
            },
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }
}
