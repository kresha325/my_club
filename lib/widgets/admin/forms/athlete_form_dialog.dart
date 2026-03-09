import 'package:flutter/material.dart';

import '../../../models/athlete.dart';
import '../../../utils/validators.dart';

class AthleteFormDialog extends StatefulWidget {
  const AthleteFormDialog({this.initial, super.key});

  final Athlete? initial;

  @override
  State<AthleteFormDialog> createState() => _AthleteFormDialogState();
}

class _AthleteFormDialogState extends State<AthleteFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _positionCtrl;
  late final TextEditingController _numberCtrl;
  late final TextEditingController _photoUrlCtrl;
  late final TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.fullName ?? '');
    _positionCtrl = TextEditingController(text: widget.initial?.position ?? '');
    _numberCtrl = TextEditingController(text: widget.initial?.number ?? '');
    _photoUrlCtrl = TextEditingController(text: widget.initial?.photoUrl ?? '');
    _bioCtrl = TextEditingController(text: widget.initial?.bio ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _positionCtrl.dispose();
    _numberCtrl.dispose();
    _photoUrlCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final result = Athlete(
      id: widget.initial?.id ?? '',
      fullName: _nameCtrl.text.trim(),
      position: _positionCtrl.text.trim(),
      number: _numberCtrl.text.trim(),
      photoUrl: _photoUrlCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
      createdAt: widget.initial?.createdAt,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit athlete' : 'Add athlete'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _positionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Position (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _numberCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Number (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _photoUrlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Photo URL (optional)',
                    helperText:
                        'Tip: upload in Admin → Gallery and paste the URL.',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bioCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Bio (optional)',
                  ),
                  maxLines: 4,
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
