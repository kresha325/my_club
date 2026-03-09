import 'package:flutter/material.dart';

import '../../models/news_item.dart';
import '../placeholder_image.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({required this.item, super.key});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (item.coverUrl.trim().isEmpty)
            const PlaceholderImage(height: 140)
          else
            Image.network(
              item.coverUrl,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const PlaceholderImage(height: 140),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title.isEmpty ? '(Empty title)' : item.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  item.body.isEmpty ? 'No content yet.' : item.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
