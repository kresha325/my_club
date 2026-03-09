import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/autopost_job.dart';
import '../../../utils/app_localizations.dart';
import '../../../utils/date_time_picker.dart';
import '../../../utils/validators.dart';

class AutopostJobFormDialog extends StatefulWidget {
  const AutopostJobFormDialog({super.key});

  @override
  State<AutopostJobFormDialog> createState() => _AutopostJobFormDialogState();
}

class _AutopostJobFormDialogState extends State<AutopostJobFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _contentIdCtrl = TextEditingController();

  String _contentType = 'news';
  bool _toYoutube = true;
  bool _toInstagram = false;
  bool _toFacebook = false;
  DateTime? _scheduledAt;

  @override
  void dispose() {
    _contentIdCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return AppLocalizations.t(context, 'notSetSendImmediately');
    return DateFormat.yMMMd().add_Hm().format(dt.toLocal());
  }

  Future<void> _pickSchedule() async {
    final picked = await pickDateTime(
      context,
      initial: _scheduledAt,
      helpText: AppLocalizations.t(context, 'scheduleAutopostHelp'),
    );
    if (picked == null) return;
    setState(() => _scheduledAt = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final platforms = <String>[
      if (_toYoutube) 'youtube',
      if (_toInstagram) 'instagram',
      if (_toFacebook) 'facebook',
    ];

    final result = AutopostJob(
      id: '',
      contentType: _contentType,
      contentId: _contentIdCtrl.text.trim(),
      platforms: platforms,
      scheduledAt: _scheduledAt,
      status: 'queued',
      lastError: '',
      createdAt: null,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.t(context, key);

    return AlertDialog(
      title: Text(tr('scheduleAutopost')),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _contentType,
                  items: [
                    DropdownMenuItem(
                      value: 'news',
                      child: Text(tr('newsItem')),
                    ),
                    DropdownMenuItem(
                      value: 'event',
                      child: Text(tr('eventItem')),
                    ),
                    DropdownMenuItem(
                      value: 'gallery',
                      child: Text(tr('galleryItem')),
                    ),
                    DropdownMenuItem(
                      value: 'match',
                      child: Text(tr('matchItem')),
                    ),
                  ],
                  onChanged: (v) => setState(() => _contentType = v ?? 'news'),
                  decoration: InputDecoration(labelText: tr('contentType')),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contentIdCtrl,
                  decoration: InputDecoration(
                    labelText: tr('contentDocumentId'),
                    helperText: tr('contentDocHelper'),
                  ),
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr('platforms'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                CheckboxListTile(
                  value: _toYoutube,
                  onChanged: (v) => setState(() => _toYoutube = v ?? false),
                  title: const Text('YouTube'),
                ),
                CheckboxListTile(
                  value: _toInstagram,
                  onChanged: (v) => setState(() => _toInstagram = v ?? false),
                  title: const Text('Instagram'),
                ),
                CheckboxListTile(
                  value: _toFacebook,
                  onChanged: (v) => setState(() => _toFacebook = v ?? false),
                  title: const Text('Facebook'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text('${tr('scheduled')}: ${_fmt(_scheduledAt)}'),
                    ),
                    TextButton.icon(
                      onPressed: _pickSchedule,
                      icon: const Icon(Icons.schedule),
                      label: Text(tr('pick')),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(tr('placeholderQueueText')),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(tr('cancel')),
        ),
        FilledButton(onPressed: _save, child: Text(tr('createJob'))),
      ],
    );
  }
}
