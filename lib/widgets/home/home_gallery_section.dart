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
        final width = MediaQuery.of(context).size.width;
        final crossAxisCount = width >= 1100
            ? 4
            : width >= 800
            ? 3
            : 2;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: 220,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) => MediaCard(item: items[index]),
          ),
        );
      },
    );
  }
}
