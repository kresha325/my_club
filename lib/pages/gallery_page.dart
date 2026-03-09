import 'package:flutter/material.dart';

import '../app/dependencies.dart';
import '../models/gallery_item.dart';
import '../widgets/cards/media_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);

    return Column(
      children: [
        const SectionHeader(title: 'Gallery'),
        Expanded(
          child: StreamBuilder<List<GalleryItem>>(
            stream: deps.galleryRepository.streamLatest(),
            builder: (context, snapshot) {
              final items = snapshot.data ?? const <GalleryItem>[];
              if (items.isEmpty) {
                return const EmptyState(
                  title: 'No gallery items yet',
                  subtitle: 'Admin will upload photos and videos.',
                  icon: Icons.photo_library_outlined,
                );
              }
              final width = MediaQuery.of(context).size.width;
              final crossAxisCount = width >= 1100
                  ? 4
                  : width >= 800
                  ? 3
                  : 2;

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisExtent: 220,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) => MediaCard(item: items[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
