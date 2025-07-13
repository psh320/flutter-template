
import 'package:flutter/material.dart';

class TipOfTheDayCard extends StatelessWidget {
  const TipOfTheDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, this might fetch a tip from a service
    const tip = "Use shared widgets in lib/core/common_widgets for functionality used across multiple features!";

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💡 Tip of the Day',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(tip),
          ],
        ),
      ),
    );
  }
}
