import 'package:flutter/material.dart';

import '../../models/gallery_item.dart';
import '../placeholder_image.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({required this.item, super.key});

  final GalleryItem item;

  @override
  Widget build(BuildContext context) {
    final isVideo = item.mediaType == GalleryMediaType.video;
    final icon = isVideo ? Icons.play_circle_outline : Icons.image_outlined;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (item.thumbnailUrl.trim().isEmpty)
            PlaceholderImage(height: 140, icon: icon)
          else
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  item.thumbnailUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      PlaceholderImage(height: 140, icon: icon),
                ),
                if (isVideo)
                  const Icon(Icons.play_circle, size: 54, color: Colors.white),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              item.caption.isEmpty ? '(Empty caption)' : item.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
