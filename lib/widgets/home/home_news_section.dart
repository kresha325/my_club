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
        final crossAxisCount = MediaQuery.of(context).size.width >= 900 ? 3 : 1;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: 240,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) => NewsCard(item: items[index]),
          ),
        );
      },
    );
  }
}
