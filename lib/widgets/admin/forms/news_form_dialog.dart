import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../../../models/news_item.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_localizations.dart';
import '../../../utils/validators.dart';

enum _CoverSourceMode { publicUrl, uploadPhoto }

String? _extensionFromName(String name) {
  final dot = name.lastIndexOf('.');
  if (dot == -1 || dot >= name.length - 1) return null;
  return name.substring(dot + 1);
}

String _guessImageContentType(String fileName) {
  final ext = _extensionFromName(fileName)?.toLowerCase();
  switch (ext) {
    case 'png':
      return 'image/png';
    case 'gif':
      return 'image/gif';
    case 'webp':
      return 'image/webp';
    case 'bmp':
      return 'image/bmp';
    case 'jpg':
    case 'jpeg':
    default:
      return 'image/jpeg';
  }
}

bool _looksLikeDirectImageUrl(String value) {
  final text = value.trim();
  if (text.isEmpty) return true;

  final uri = Uri.tryParse(text);
  if (uri == null || !(uri.scheme == 'http' || uri.scheme == 'https')) {
    return false;
  }

  final path = uri.path.toLowerCase();
  return path.endsWith('.jpg') ||
      path.endsWith('.jpeg') ||
      path.endsWith('.png') ||
      path.endsWith('.webp') ||
      path.endsWith('.gif') ||
      path.endsWith('.bmp') ||
      path.endsWith('.svg');
}

class NewsFormDialog extends StatefulWidget {
  const NewsFormDialog({this.initial, super.key});

  final NewsItem? initial;

  @override
  State<NewsFormDialog> createState() => _NewsFormDialogState();
}

class _NewsFormDialogState extends State<NewsFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;
  late final TextEditingController _coverUrlCtrl;

  _CoverSourceMode _coverSourceMode = _CoverSourceMode.publicUrl;
  Uint8List? _coverBytes;
  String _coverFileName = '';
  String _error = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _bodyCtrl = TextEditingController(text: widget.initial?.body ?? '');
    _coverUrlCtrl = TextEditingController(text: widget.initial?.coverUrl ?? '');
    _coverSourceMode = _coverUrlCtrl.text.trim().isNotEmpty
        ? _CoverSourceMode.publicUrl
        : _CoverSourceMode.uploadPhoto;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _coverUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    setState(() => _error = '');
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null) {
      setState(() => _error = 'Could not read selected photo bytes.');
      return;
    }

    setState(() {
      _coverBytes = file.bytes;
      _coverFileName = file.name;
      _error = '';
    });
  }

  Future<String> _uploadCoverImage() async {
    final bytes = _coverBytes;
    if (bytes == null || _coverFileName.isEmpty) {
      throw StateError(AppLocalizations.t(context, 'pickPhotoFirst'));
    }

    final deps = DependenciesScope.of(context);
    final safeName = _coverFileName.replaceAll(' ', '_');
    final path =
        '${AppConstants.storageClubMediaRoot}/news/${DateTime.now().millisecondsSinceEpoch}_$safeName';
    return deps.mediaStorageService.uploadBytes(
      path: path,
      bytes: bytes,
      contentType: _guessImageContentType(_coverFileName),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSaving = true;
      _error = '';
    });

    try {
      var coverUrl = _coverUrlCtrl.text.trim();
      if (_coverSourceMode == _CoverSourceMode.uploadPhoto) {
        coverUrl = await _uploadCoverImage();
      }

      final now = DateTime.now();

      final result = NewsItem(
        id: widget.initial?.id ?? '',
        title: _titleCtrl.text.trim(),
        body: _bodyCtrl.text.trim(),
        coverUrl: coverUrl,
        publishedAt: widget.initial?.publishedAt ?? now,
        createdAt: widget.initial?.createdAt,
      );
      if (mounted) Navigator.of(context).pop(result);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    String tr(String key) => AppLocalizations.t(context, key);

    return AlertDialog(
      title: Text(isEdit ? tr('editNews') : tr('addNews')),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleCtrl,
                  decoration: InputDecoration(labelText: tr('title')),
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr('coverImageSource'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                RadioGroup<_CoverSourceMode>(
                  groupValue: _coverSourceMode,
                  onChanged: (v) {
                    if (_isSaving || v == null) return;
                    setState(() {
                      _coverSourceMode = v;
                      _error = '';
                    });
                  },
                  child: Column(
                    children: [
                      RadioListTile<_CoverSourceMode>(
                        value: _CoverSourceMode.publicUrl,
                        title: Text(tr('usePublicUrl')),
                        contentPadding: EdgeInsets.zero,
                      ),
                      RadioListTile<_CoverSourceMode>(
                        value: _CoverSourceMode.uploadPhoto,
                        title: Text(tr('uploadPhoto')),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                if (_coverSourceMode == _CoverSourceMode.publicUrl)
                  TextFormField(
                    controller: _coverUrlCtrl,
                    decoration: InputDecoration(
                      labelText: tr('coverImageUrlOptional'),
                      helperText: tr('directImageUrlTip'),
                    ),
                    validator: (value) {
                      if (_coverSourceMode != _CoverSourceMode.publicUrl) {
                        return null;
                      }
                      final text = (value ?? '').trim();
                      if (text.isEmpty) return null;
                      if (_looksLikeDirectImageUrl(text)) return null;
                      return tr('directImageUrlError');
                    },
                  )
                else
                  OutlinedButton.icon(
                    onPressed: _isSaving ? null : _pickPhoto,
                    icon: const Icon(Icons.image_outlined),
                    label: Text(
                      _coverFileName.isEmpty
                          ? tr('pickPhoto')
                          : '${tr('selectedPhoto')}: $_coverFileName',
                    ),
                  ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bodyCtrl,
                  decoration: InputDecoration(
                    labelText: tr('bodyOptional'),
                    helperText: tr('keepBlankLater'),
                  ),
                  maxLines: 6,
                ),
                if (_error.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(tr('cancel')),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: Text(_isSaving ? tr('uploading') : tr('save')),
        ),
      ],
    );
  }
}
