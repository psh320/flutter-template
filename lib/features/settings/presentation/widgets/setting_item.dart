
import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const SettingItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: theme.colorScheme.secondary),
      title: Text(text, style: theme.textTheme.bodyLarge),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Handle tap
      },
    );
  }
}
