import 'package:flutter/material.dart';

import '../app/dependencies.dart';
import '../models/gallery_item.dart';
import '../utils/app_localizations.dart';
import '../widgets/cards/media_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    String tr(String key) => AppLocalizations.t(context, key);

    return Column(
      children: [
        SectionHeader(title: tr('gallery')),
        Expanded(
          child: StreamBuilder<List<GalleryItem>>(
            stream: deps.galleryRepository.streamLatest(),
            builder: (context, snapshot) {
              final items = snapshot.data ?? const <GalleryItem>[];
              if (items.isEmpty) {
                return EmptyState(
                  title: tr('noGalleryYet'),
                  subtitle: tr('galleryEmptySubtitle'),
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
