import 'package:flutter/material.dart';

import '../../models/news_item.dart';
import '../cards/news_card.dart';
import '../empty_state.dart';

class HomeNewsSection extends StatelessWidget {
  const HomeNewsSection({required this.stream, super.key});

  final Stream<List<NewsItem>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NewsItem>>(
      stream: stream,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <NewsItem>[];
        if (items.isEmpty) {
          return const EmptyState(
            title: 'No news yet',
            subtitle: 'Admin will add club news here.',
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth < 700
                ? constraints.maxWidth - 32
                : 360.0;
            return SizedBox(
              height: 260,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) => SizedBox(
                  width: cardWidth,
                  child: NewsCard(item: items[index]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
