import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/club_event.dart';
import '../../../utils/date_time_picker.dart';
import '../../../utils/validators.dart';

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
      helpText: 'Event start',
    );
    if (picked == null) return;
    setState(() => _startAt = picked);
  }

  Future<void> _pickEnd() async {
    final picked = await pickDateTime(
      context,
      initial: _endAt,
      helpText: 'Event end',
    );
    if (picked == null) return;
    setState(() => _endAt = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final result = ClubEvent(
      id: widget.initial?.id ?? '',
      title: _titleCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      startAt: _startAt,
      endAt: _endAt,
      bannerUrl: _bannerUrlCtrl.text.trim(),
      createdAt: widget.initial?.createdAt,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit event' : 'Add event'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Location (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Text('Start: ${_fmt(_startAt)}')),
                    TextButton.icon(
                      onPressed: _pickStart,
                      icon: const Icon(Icons.schedule),
                      label: const Text('Pick'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text('End: ${_fmt(_endAt)}')),
                    TextButton.icon(
                      onPressed: _pickEnd,
                      icon: const Icon(Icons.schedule),
                      label: const Text('Pick'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bannerUrlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Banner URL (optional)',
                    helperText:
                        'Tip: upload in Admin → Gallery and paste the URL.',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                  ),
                  maxLines: 5,
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
