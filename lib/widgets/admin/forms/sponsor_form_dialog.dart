import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../app/dependencies.dart';
import '../../../models/sponsor.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_localizations.dart';
import '../../../utils/validators.dart';

enum _LogoSourceMode { publicUrl, uploadPhoto }

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

class SponsorFormDialog extends StatefulWidget {
  const SponsorFormDialog({this.initial, super.key});

  final Sponsor? initial;

  @override
  State<SponsorFormDialog> createState() => _SponsorFormDialogState();
}

class _SponsorFormDialogState extends State<SponsorFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _tierCtrl;
  late final TextEditingController _logoUrlCtrl;
  late final TextEditingController _websiteUrlCtrl;
  _LogoSourceMode _logoSourceMode = _LogoSourceMode.publicUrl;
  Uint8List? _logoBytes;
  String _logoFileName = '';
  String _error = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _tierCtrl = TextEditingController(text: widget.initial?.tier ?? '');
    _logoUrlCtrl = TextEditingController(text: widget.initial?.logoUrl ?? '');
    _websiteUrlCtrl = TextEditingController(
      text: widget.initial?.websiteUrl ?? '',
    );
    _logoSourceMode = _logoUrlCtrl.text.trim().isNotEmpty
        ? _LogoSourceMode.publicUrl
        : _LogoSourceMode.uploadPhoto;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _tierCtrl.dispose();
    _logoUrlCtrl.dispose();
    _websiteUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickLogoPhoto() async {
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
      _logoBytes = file.bytes;
      _logoFileName = file.name;
      _error = '';
    });
  }

  Future<String> _uploadLogoImage() async {
    final bytes = _logoBytes;
    if (bytes == null || _logoFileName.isEmpty) {
      throw StateError(AppLocalizations.t(context, 'pickPhotoFirst'));
    }

    final deps = DependenciesScope.of(context);
    final safeName = _logoFileName.replaceAll(' ', '_');
    final path =
        '${AppConstants.storageClubMediaRoot}/sponsors/${DateTime.now().millisecondsSinceEpoch}_$safeName';
    return deps.mediaStorageService.uploadBytes(
      path: path,
      bytes: bytes,
      contentType: _guessImageContentType(_logoFileName),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _error = '';
    });

    try {
      var logoUrl = _logoUrlCtrl.text.trim();
      if (_logoSourceMode == _LogoSourceMode.uploadPhoto) {
        logoUrl = await _uploadLogoImage();
      }

      final result = Sponsor(
        id: widget.initial?.id ?? '',
        name: _nameCtrl.text.trim(),
        tier: _tierCtrl.text.trim(),
        logoUrl: logoUrl,
        websiteUrl: _websiteUrlCtrl.text.trim(),
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
      title: Text(isEdit ? tr('editSponsor') : tr('addSponsor')),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(labelText: tr('name')),
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tierCtrl,
                  decoration: InputDecoration(
                    labelText: tr('tierOptional'),
                    helperText: tr('tierExample'),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr('logoImageSource'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                RadioListTile<_LogoSourceMode>(
                  value: _LogoSourceMode.publicUrl,
                  groupValue: _logoSourceMode,
                  onChanged: _isSaving
                      ? null
                      : (v) => setState(() {
                          _logoSourceMode = v!;
                          _error = '';
                        }),
                  title: Text(tr('usePublicUrl')),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<_LogoSourceMode>(
                  value: _LogoSourceMode.uploadPhoto,
                  groupValue: _logoSourceMode,
                  onChanged: _isSaving
                      ? null
                      : (v) => setState(() {
                          _logoSourceMode = v!;
                          _error = '';
                        }),
                  title: Text(tr('uploadPhoto')),
                  contentPadding: EdgeInsets.zero,
                ),
                if (_logoSourceMode == _LogoSourceMode.publicUrl)
                  TextFormField(
                    controller: _logoUrlCtrl,
                    decoration: InputDecoration(
                      labelText: tr('logoUrlOptional'),
                      helperText: tr('galleryUrlTip'),
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: _isSaving ? null : _pickLogoPhoto,
                    icon: const Icon(Icons.image_outlined),
                    label: Text(
                      _logoFileName.isEmpty
                          ? tr('pickPhoto')
                          : '${tr('selectedPhoto')}: $_logoFileName',
                    ),
                  ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _websiteUrlCtrl,
                  decoration: InputDecoration(
                    labelText: tr('websiteUrlOptional'),
                  ),
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
