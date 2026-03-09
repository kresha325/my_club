import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../../../models/gallery_item.dart';
import '../../../utils/app_constants.dart';

class GalleryUploadDialog extends StatefulWidget {
  const GalleryUploadDialog({super.key});

  @override
  State<GalleryUploadDialog> createState() => _GalleryUploadDialogState();
}

String? _extensionFromName(String name) {
  final dot = name.lastIndexOf('.');
  if (dot == -1 || dot >= name.length - 1) return null;
  return name.substring(dot + 1);
}

String? _guessContentType(PlatformFile file) {
  final ext = (file.extension ?? _extensionFromName(file.name))?.toLowerCase();
  if (ext == null || ext.isEmpty) return null;

  const map = <String, String>{
    // Images
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'webp': 'image/webp',
    'bmp': 'image/bmp',
    'svg': 'image/svg+xml',
    'heic': 'image/heic',
    'heif': 'image/heif',

    // Video
    'mp4': 'video/mp4',
    'mov': 'video/quicktime',
    'm4v': 'video/x-m4v',
    'webm': 'video/webm',
    'avi': 'video/x-msvideo',
    'mkv': 'video/x-matroska',

    // Audio
    'mp3': 'audio/mpeg',
    'wav': 'audio/wav',
    'aac': 'audio/aac',
    'm4a': 'audio/mp4',

    // Docs
    'pdf': 'application/pdf',
  };
  return map[ext];
}

class _GalleryUploadDialogState extends State<GalleryUploadDialog> {
  final _formKey = GlobalKey<FormState>();
  final _captionCtrl = TextEditingController();

  Uint8List? _bytes;
  String _fileName = '';
  String? _contentType;
  bool _isVideo = false;
  bool _isUploading = false;
  String _error = '';

  @override
  void dispose() {
    _captionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    setState(() => _error = '');
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null) {
      setState(() => _error = 'Could not read file bytes. Try another file.');
      return;
    }

    setState(() {
      _bytes = file.bytes;
      _fileName = file.name;
      _contentType = _guessContentType(file);
    });
  }

  Future<void> _upload() async {
    if (!_formKey.currentState!.validate()) return;
    if (_bytes == null || _fileName.isEmpty) {
      setState(() => _error = 'Pick a file first.');
      return;
    }

    setState(() {
      _isUploading = true;
      _error = '';
    });

    try {
      final deps = DependenciesScope.of(context);
      final safeName = _fileName.replaceAll(' ', '_');
      final path =
          '${AppConstants.storageClubMediaRoot}/gallery/${DateTime.now().millisecondsSinceEpoch}_$safeName';

      final url = await deps.mediaStorageService.uploadBytes(
        path: path,
        bytes: _bytes!,
        contentType: _contentType,
      );

      final item = GalleryItem(
        id: '',
        caption: _captionCtrl.text.trim(),
        mediaUrl: url,
        thumbnailUrl: _isVideo ? '' : url,
        mediaType: _isVideo ? GalleryMediaType.video : GalleryMediaType.image,
        createdAt: null,
      );

      if (mounted) Navigator.of(context).pop(item);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Upload gallery media'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: _isUploading ? null : _pickFile,
                  icon: const Icon(Icons.upload_file_outlined),
                  label: Text(
                    _fileName.isEmpty ? 'Pick file' : 'Picked: $_fileName',
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('This file is a video'),
                  subtitle: const Text(
                    'Video thumbnails are a TODO placeholder.',
                  ),
                  value: _isVideo,
                  onChanged: _isUploading
                      ? null
                      : (v) => setState(() => _isVideo = v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _captionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Caption (optional)',
                    helperText: 'Keep blank for now; admin can edit later.',
                  ),
                  validator: (v) {
                    // Optional field; keep validation for future extensions.
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                if (_error.isNotEmpty)
                  Text(
                    _error,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                const SizedBox(height: 8),
                const Text(
                  'Uploads to Firebase Storage, then creates a Firestore `gallery` doc.\n'
                  'Developer: add real video thumbnail generation via Cloud Functions.',
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isUploading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isUploading ? null : _upload,
          child: Text(_isUploading ? 'Uploading…' : 'Upload'),
        ),
      ],
    );
  }
}
