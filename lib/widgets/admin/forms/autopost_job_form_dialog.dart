import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/autopost_job.dart';
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
    if (dt == null) return 'Not set (send immediately)';
    return DateFormat.yMMMd().add_Hm().format(dt.toLocal());
  }

  Future<void> _pickSchedule() async {
    final picked = await pickDateTime(
      context,
      initial: _scheduledAt,
      helpText: 'Schedule autopost',
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
    return AlertDialog(
      title: const Text('Schedule autopost'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _contentType,
                  items: const [
                    DropdownMenuItem(value: 'news', child: Text('News')),
                    DropdownMenuItem(value: 'event', child: Text('Event')),
                    DropdownMenuItem(
                      value: 'gallery',
                      child: Text('Gallery item'),
                    ),
                    DropdownMenuItem(value: 'match', child: Text('Match')),
                  ],
                  onChanged: (v) => setState(() => _contentType = v ?? 'news'),
                  decoration: const InputDecoration(labelText: 'Content type'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contentIdCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Content document ID',
                    helperText: 'Paste the Firestore doc id you want to post.',
                  ),
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Platforms',
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
                    Expanded(child: Text('Scheduled: ${_fmt(_scheduledAt)}')),
                    TextButton.icon(
                      onPressed: _pickSchedule,
                      icon: const Icon(Icons.schedule),
                      label: const Text('Pick'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'This is a placeholder queue.\n'
                  'Firebase Functions will process jobs and call platform APIs '
                  '(see functions/src/autopost/*).',
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
        FilledButton(onPressed: _save, child: const Text('Create job')),
      ],
    );
  }
}
