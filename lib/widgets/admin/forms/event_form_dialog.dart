import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/dependencies.dart';
import '../../../models/club_event.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_localizations.dart';
import '../../../utils/date_time_picker.dart';
import '../../../utils/validators.dart';

enum _BannerSourceMode { publicUrl, uploadPhoto }

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

class EventFormDialog extends StatefulWidget {
  const EventFormDialog({this.initial, super.key});

  final ClubEvent? initial;

  @override
  State<EventFormDialog> createState() => _EventFormDialogState();
}

class _EventFormDialogState extends State<EventFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _bannerUrlCtrl;

  DateTime? _startAt;
  DateTime? _endAt;
  _BannerSourceMode _bannerSourceMode = _BannerSourceMode.publicUrl;
  Uint8List? _bannerBytes;
  String _bannerFileName = '';
  String _error = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _descriptionCtrl = TextEditingController(
      text: widget.initial?.description ?? '',
    );
    _locationCtrl = TextEditingController(text: widget.initial?.location ?? '');
    _bannerUrlCtrl = TextEditingController(
      text: widget.initial?.bannerUrl ?? '',
    );
    _bannerSourceMode = _bannerUrlCtrl.text.trim().isNotEmpty
        ? _BannerSourceMode.publicUrl
        : _BannerSourceMode.uploadPhoto;
    _startAt = widget.initial?.startAt;
    _endAt = widget.initial?.endAt;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _locationCtrl.dispose();
    _bannerUrlCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return 'Not set';
    return DateFormat.yMMMd().add_Hm().format(dt.toLocal());
  }

  Future<void> _pickStart() async {
    final picked = await pickDateTime(
      context,
      initial: _startAt,
      helpText: AppLocalizations.t(context, 'eventStartHelp'),
    );
    if (picked == null) return;
    setState(() => _startAt = picked);
  }

  Future<void> _pickEnd() async {
    final picked = await pickDateTime(
      context,
      initial: _endAt,
      helpText: AppLocalizations.t(context, 'eventEndHelp'),
    );
    if (picked == null) return;
    setState(() => _endAt = picked);
  }

  Future<void> _pickBannerPhoto() async {
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
      _bannerBytes = file.bytes;
      _bannerFileName = file.name;
      _error = '';
    });
  }

  Future<String> _uploadBannerImage() async {
    final bytes = _bannerBytes;
    if (bytes == null || _bannerFileName.isEmpty) {
      throw StateError(AppLocalizations.t(context, 'pickPhotoFirst'));
    }

    final deps = DependenciesScope.of(context);
    final safeName = _bannerFileName.replaceAll(' ', '_');
    final path =
        '${AppConstants.storageClubMediaRoot}/events/${DateTime.now().millisecondsSinceEpoch}_$safeName';
    return deps.mediaStorageService.uploadBytes(
      path: path,
      bytes: bytes,
      contentType: _guessImageContentType(_bannerFileName),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _error = '';
    });

    try {
      var bannerUrl = _bannerUrlCtrl.text.trim();
      if (_bannerSourceMode == _BannerSourceMode.uploadPhoto) {
        bannerUrl = await _uploadBannerImage();
      }

      final result = ClubEvent(
        id: widget.initial?.id ?? '',
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        location: _locationCtrl.text.trim(),
        startAt: _startAt,
        endAt: _endAt,
        bannerUrl: bannerUrl,
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
      title: Text(isEdit ? tr('editEvent') : tr('addEvent')),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
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
                TextFormField(
                  controller: _locationCtrl,
                  decoration: InputDecoration(
                    labelText: tr('locationOptional'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Text('${tr('start')}: ${_fmt(_startAt)}')),
                    TextButton.icon(
                      onPressed: _pickStart,
                      icon: const Icon(Icons.schedule),
                      label: Text(tr('pick')),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text('${tr('end')}: ${_fmt(_endAt)}')),
                    TextButton.icon(
                      onPressed: _pickEnd,
                      icon: const Icon(Icons.schedule),
                      label: Text(tr('pick')),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr('bannerImageSource'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                RadioListTile<_BannerSourceMode>(
                  value: _BannerSourceMode.publicUrl,
                  groupValue: _bannerSourceMode,
                  onChanged: _isSaving
                      ? null
                      : (v) => setState(() {
                          _bannerSourceMode = v!;
                          _error = '';
                        }),
                  title: Text(tr('usePublicUrl')),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<_BannerSourceMode>(
                  value: _BannerSourceMode.uploadPhoto,
                  groupValue: _bannerSourceMode,
                  onChanged: _isSaving
                      ? null
                      : (v) => setState(() {
                          _bannerSourceMode = v!;
                          _error = '';
                        }),
                  title: Text(tr('uploadPhoto')),
                  contentPadding: EdgeInsets.zero,
                ),
                if (_bannerSourceMode == _BannerSourceMode.publicUrl)
                  TextFormField(
                    controller: _bannerUrlCtrl,
                    decoration: InputDecoration(
                      labelText: tr('bannerUrlOptional'),
                      helperText: tr('galleryUrlTip'),
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: _isSaving ? null : _pickBannerPhoto,
                    icon: const Icon(Icons.image_outlined),
                    label: Text(
                      _bannerFileName.isEmpty
                          ? tr('pickPhoto')
                          : '${tr('selectedPhoto')}: $_bannerFileName',
                    ),
                  ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionCtrl,
                  decoration: InputDecoration(
                    labelText: tr('descriptionOptional'),
                  ),
                  maxLines: 5,
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
