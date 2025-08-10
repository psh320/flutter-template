
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profitable_flutter_app/core/common_widgets/tip_of_the_day_card.dart';
import 'package:profitable_flutter_app/core/services/api_service.dart';
import 'package:profitable_flutter_app/service_locator.dart';

final postsProvider = FutureProvider<List<dynamic>>((ref) async {
  final apiService = getIt<ApiService>();
  final response = await apiService.get('/posts');
  return response.data;
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    final theme = Theme.of(context);

    return posts.when(
      data: (data) {
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: data.length + 1, // Add 1 for the tip card
          itemBuilder: (context, index) {
            if (index == 0) {
              return const TipOfTheDayCard();
            }
            final postIndex = index - 1;
            return ListTile(
              title: Text(data[postIndex]['title'], style: theme.textTheme.headlineMedium),
              subtitle: Text(data[postIndex]['body'], style: theme.textTheme.bodyLarge),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
