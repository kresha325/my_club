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
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'webp': 'image/webp',
    'bmp': 'image/bmp',
    'svg': 'image/svg+xml',
    'heic': 'image/heic',
    'heif': 'image/heif',
    'mp4': 'video/mp4',
    'mov': 'video/quicktime',
    'm4v': 'video/x-m4v',
    'webm': 'video/webm',
    'avi': 'video/x-msvideo',
    'mkv': 'video/x-matroska',
    'mp3': 'audio/mpeg',
    'wav': 'audio/wav',
    'aac': 'audio/aac',
    'm4a': 'audio/mp4',
    'pdf': 'application/pdf',
  };
  return map[ext];
}

String _normalizedPath(String url) {
  final lower = url.toLowerCase();
  final q = lower.indexOf('?');
  final h = lower.indexOf('#');
  final cut = [
    q,
    h,
  ].where((i) => i >= 0).fold<int>(lower.length, (min, i) => i < min ? i : min);
  return lower.substring(0, cut);
}

bool _looksLikeVideoUrl(String url) {
  final path = _normalizedPath(url);
  return path.endsWith('.mp4') ||
      path.endsWith('.mov') ||
      path.endsWith('.m4v') ||
      path.endsWith('.webm') ||
      path.endsWith('.avi') ||
      path.endsWith('.mkv');
}

bool _looksLikeImageUrl(String url) {
  final path = _normalizedPath(url);
  return path.endsWith('.jpg') ||
      path.endsWith('.jpeg') ||
      path.endsWith('.png') ||
      path.endsWith('.webp') ||
      path.endsWith('.gif') ||
      path.endsWith('.bmp');
}

class _GalleryUploadDialogState extends State<GalleryUploadDialog> {
  final _formKey = GlobalKey<FormState>();
  final _captionCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _manualUrlCtrl = TextEditingController();

  Uint8List? _bytes;
  String _fileName = '';
  String? _contentType;
  bool _isVideo = false;
  bool _toFacebook = false;
  bool _toInstagram = false;
  bool _toYoutube = false;
  bool _useManualUrl = false;
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
    _durationCtrl.dispose();
    _manualUrlCtrl.dispose();
    super.dispose();
  }

  int? _parseDurationSeconds() {
    final raw = _durationCtrl.text.trim();
    if (raw.isEmpty) return null;
    final parsed = int.tryParse(raw);
    if (parsed == null || parsed <= 0) return null;
    return parsed;
  }

  Future<void> _pickFile() async {
    if (_isUploading) return;
    setState(() => _error = '');

    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null) {
      if (mounted) {
        setState(() => _error = 'Could not read file bytes. Try another file.');
      }
      return;
    }

    if (!mounted) return;
    setState(() {
      _bytes = file.bytes;
      _fileName = file.name;
      _contentType = _guessContentType(file);
    });
  }

  Future<void> _upload() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_useManualUrl && (_bytes == null || _fileName.isEmpty)) {
      setState(() => _error = AppLocalizations.t(context, 'pickFile'));
      return;
    }

    final manualUrl = _manualUrlCtrl.text.trim();
    if (_useManualUrl && manualUrl.isEmpty) {
      setState(() => _error = 'URL is required');
      return;
    }

    setState(() {
      _isUploading = true;
      _error = '';
    });

    try {
      String url;
      bool mediaIsVideo = _isVideo;

      if (_useManualUrl) {
        url = manualUrl;
        if (_looksLikeVideoUrl(url)) {
          mediaIsVideo = true;
        } else if (_looksLikeImageUrl(url)) {
          mediaIsVideo = false;
        }
      } else {
        final deps = DependenciesScope.of(context);
        final safeName = _fileName.replaceAll(' ', '_');
        final path =
            '${AppConstants.storageClubMediaRoot}/gallery/${DateTime.now().millisecondsSinceEpoch}_$safeName';

        url = await deps.mediaStorageService.uploadBytes(
          path: path,
          bytes: _bytes!,
          contentType: _contentType,
        );
      }

      final item = GalleryItem(
        id: '',
        caption: _captionCtrl.text.trim(),
        mediaUrl: url,
        thumbnailUrl: mediaIsVideo ? (_looksLikeImageUrl(url) ? url : '') : url,
        mediaType: mediaIsVideo
            ? GalleryMediaType.video
            : GalleryMediaType.image,
        durationSeconds: mediaIsVideo ? _parseDurationSeconds() : null,
        autopostEnabled: _selectedPlatforms().isNotEmpty,
        autopostPlatforms: _selectedPlatforms(),
        createdAt: null,
      );

      if (mounted) Navigator.of(context).pop(item);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
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
                  onPressed: _isUploading || _useManualUrl ? null : _pickFile,
                  icon: const Icon(Icons.upload_file_outlined),
                  label: Text(
                    _fileName.isEmpty
                        ? tr('pickFile')
                        : '${tr('picked')}: $_fileName',
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Use public URL instead of upload'),
                  subtitle: const Text(
                    'Testing mode when Firebase Storage is not active.',
                  ),
                  value: _useManualUrl,
                  onChanged: _isUploading
                      ? null
                      : (v) => setState(() {
                          _useManualUrl = v;
                          _error = '';
                        }),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _manualUrlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Public media URL',
                    helperText: 'Example: direct .jpg/.png/.mp4 link',
                  ),
                  validator: (value) {
                    if (!_useManualUrl) return null;
                    final text = (value ?? '').trim();
                    if (text.isEmpty) return 'URL is required';
                    if (!text.startsWith('http://') &&
                        !text.startsWith('https://')) {
                      return 'Use http:// or https:// URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: Text(tr('thisFileIsVideo')),
                  subtitle: Text(tr('videoThumbTodo')),
                  value: _isVideo,
                  onChanged: _isUploading
                      ? null
                      : (v) => setState(() {
                          _isVideo = v;
                          if (!v) _durationCtrl.clear();
                        }),
                ),
                if (_isVideo) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _durationCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: tr('videoDurationSecondsOptional'),
                      helperText: tr('videoDurationHelp'),
                    ),
                    validator: (value) {
                      final text = (value ?? '').trim();
                      if (text.isEmpty) return null;
                      final parsed = int.tryParse(text);
                      if (parsed == null || parsed <= 0) {
                        return tr('videoDurationInvalid');
                      }
                      return null;
                    },
                  ),
                ],
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
