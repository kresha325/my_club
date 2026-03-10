import 'package:flutter/material.dart';

import '../../models/gallery_item.dart';
import '../cards/media_card.dart';
import '../empty_state.dart';

class HomeGallerySection extends StatelessWidget {
  const HomeGallerySection({required this.stream, super.key});

  final Stream<List<GalleryItem>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GalleryItem>>(
      stream: stream,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <GalleryItem>[];
        if (items.isEmpty) {
          return const EmptyState(
            title: 'No media yet',
            subtitle: 'Photos and videos will appear here.',
            icon: Icons.photo_library_outlined,
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth < 700
                ? constraints.maxWidth - 32
                : 280.0;
            return SizedBox(
              height: 230,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) => SizedBox(
                  width: cardWidth,
                  child: MediaCard(item: items[index]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
