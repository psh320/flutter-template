
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:profitable_flutter_app/core/widgets/primary_button.dart';
import 'package:profitable_flutter_app/features/settings/presentation/widgets/setting_item.dart';
import 'package:profitable_flutter_app/core/theme_notifier.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Settings',
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const SettingItem(
          icon: Icons.person,
          text: 'Account',
        ),
        const SettingItem(
          icon: Icons.notifications,
          text: 'Notifications',
        ),
        const SettingItem(
          icon: Icons.lock,
          text: 'Privacy & Security',
        ),
        const SettingItem(
          icon: Icons.help_outline,
          text: 'Help & Support',
        ),
        SwitchListTile(
          title: const Text('Dark Mode'),
          value: themeNotifier.isDarkMode,
          onChanged: (value) {
            themeNotifier.toggleTheme();
          },
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          onPressed: () {},
          text: 'Logout',
        ),
      ],
    );
  }
}
