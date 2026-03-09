import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../models/gallery_item.dart';
import '../../widgets/admin/admin_access_gate.dart';
import '../../widgets/admin/confirm_delete_dialog.dart';
import '../../widgets/admin/forms/gallery_item_edit_dialog.dart';
import '../../widgets/admin/forms/gallery_upload_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class AdminGalleryPage extends StatelessWidget {
  const AdminGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);

    return AdminAccessGate(
      child: Column(
        children: [
          SectionHeader(
            title: 'Gallery',
            trailing: FilledButton.icon(
              onPressed: () async {
                final result = await showDialog<GalleryItem>(
                  context: context,
                  builder: (context) => const GalleryUploadDialog(),
                );
                if (result == null) return;
                await deps.galleryRepository.create(result);
              },
              icon: const Icon(Icons.upload_file_outlined),
              label: const Text('Upload'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<GalleryItem>>(
              stream: deps.galleryRepository.streamLatest(limit: 200),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <GalleryItem>[];
                if (items.isEmpty) {
                  return const EmptyState(
                    title: 'No media',
                    subtitle:
                        'Upload photos/videos to populate the public Gallery page.',
                    icon: Icons.photo_library_outlined,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final type = item.mediaType == GalleryMediaType.video
                        ? 'Video'
                        : 'Image';
                    final platforms =
                        item.autopostEnabled &&
                            item.autopostPlatforms.isNotEmpty
                        ? item.autopostPlatforms.join(', ')
                        : 'off';

                    return Card(
                      child: ListTile(
                        leading: Icon(
                          item.mediaType == GalleryMediaType.video
                              ? Icons.play_circle_outline
                              : Icons.image_outlined,
                        ),
                        title: Text(
                          item.caption.isEmpty
                              ? '(Empty caption)'
                              : item.caption,
                        ),
                        subtitle: Text(
                          '$type • Autopost: $platforms • URL stored in Firestore',
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () async {
                                final updated = await showDialog<GalleryItem>(
                                  context: context,
                                  builder: (context) =>
                                      GalleryItemEditDialog(initial: item),
                                );
                                if (updated == null) return;
                                await deps.galleryRepository.update(updated);
                              },
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  entityLabel: 'gallery item "${item.caption}"',
                                );
                                if (!confirmed) return;
                                await deps.galleryRepository.delete(item.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
