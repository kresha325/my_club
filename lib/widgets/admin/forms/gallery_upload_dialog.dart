import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../../../models/gallery_item.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_localizations.dart';

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
  bool _toFacebook = false;
  bool _toInstagram = false;
  bool _toYoutube = false;
  bool _isUploading = false;
  String _error = '';

  List<String> _selectedPlatforms() {
    return <String>[
      if (_toFacebook) 'facebook',
      if (_toInstagram) 'instagram',
      if (_toYoutube) 'youtube',
    ];
  }

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
      setState(() => _error = AppLocalizations.t(context, 'pickFile'));
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
        autopostEnabled: _selectedPlatforms().isNotEmpty,
        autopostPlatforms: _selectedPlatforms(),
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
    String tr(String key) => AppLocalizations.t(context, key);

    return AlertDialog(
      title: Text(tr('uploadGalleryMedia')),
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
                    _fileName.isEmpty
                        ? tr('pickFile')
                        : '${tr('picked')}: $_fileName',
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: Text(tr('thisFileIsVideo')),
                  subtitle: Text(tr('videoThumbTodo')),
                  value: _isVideo,
                  onChanged: _isUploading
                      ? null
                      : (v) => setState(() => _isVideo = v),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr('autopostPlatformsForThisMedia'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                CheckboxListTile(
                  value: _toFacebook,
                  onChanged: _isUploading
                      ? null
                      : (v) => setState(() => _toFacebook = v ?? false),
                  title: Text(tr('facebook')),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  value: _toInstagram,
                  onChanged: _isUploading
                      ? null
                      : (v) => setState(() => _toInstagram = v ?? false),
                  title: Text(tr('instagram')),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  value: _toYoutube,
                  onChanged: _isUploading
                      ? null
                      : (v) => setState(() => _toYoutube = v ?? false),
                  title: Text(tr('youtube')),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr('autopostNoPlatformMeansOff'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _captionCtrl,
                  decoration: InputDecoration(
                    labelText: tr('captionOptional'),
                    helperText: tr('keepBlankLater'),
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
                Text(tr('uploadsInfoText')),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isUploading ? null : () => Navigator.of(context).pop(),
          child: Text(tr('cancel')),
        ),
        FilledButton(
          onPressed: _isUploading ? null : _upload,
          child: Text(_isUploading ? tr('uploading') : tr('upload')),
        ),
      ],
    );
  }
}
