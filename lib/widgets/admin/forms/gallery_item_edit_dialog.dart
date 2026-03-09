import 'package:flutter/material.dart';

import '../../../models/gallery_item.dart';

class GalleryItemEditDialog extends StatefulWidget {
  const GalleryItemEditDialog({required this.initial, super.key});

  final GalleryItem initial;

  @override
  State<GalleryItemEditDialog> createState() => _GalleryItemEditDialogState();
}

class _GalleryItemEditDialogState extends State<GalleryItemEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _captionCtrl;
  late final TextEditingController _thumbnailCtrl;

  @override
  void initState() {
    super.initState();
    _captionCtrl = TextEditingController(text: widget.initial.caption);
    _thumbnailCtrl = TextEditingController(text: widget.initial.thumbnailUrl);
  }

  @override
  void dispose() {
    _captionCtrl.dispose();
    _thumbnailCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      widget.initial.copyWith(
        caption: _captionCtrl.text.trim(),
        thumbnailUrl: _thumbnailCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = widget.initial.mediaType == GalleryMediaType.video;

    return AlertDialog(
      title: const Text('Edit gallery item'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _captionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Caption (optional)',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                if (isVideo)
                  TextFormField(
                    controller: _thumbnailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Thumbnail URL (optional)',
                      helperText:
                          'For videos, add a thumbnail URL (or generate one via Cloud Functions).',
                    ),
                  ),
                const SizedBox(height: 8),
                const Text(
                  'Developer: store additional metadata here (tags, categories, etc).',
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
