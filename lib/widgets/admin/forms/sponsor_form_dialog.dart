import 'package:flutter/material.dart';

import '../../../models/sponsor.dart';
import '../../../utils/validators.dart';

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

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _tierCtrl = TextEditingController(text: widget.initial?.tier ?? '');
    _logoUrlCtrl = TextEditingController(text: widget.initial?.logoUrl ?? '');
    _websiteUrlCtrl = TextEditingController(
      text: widget.initial?.websiteUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _tierCtrl.dispose();
    _logoUrlCtrl.dispose();
    _websiteUrlCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final result = Sponsor(
      id: widget.initial?.id ?? '',
      name: _nameCtrl.text.trim(),
      tier: _tierCtrl.text.trim(),
      logoUrl: _logoUrlCtrl.text.trim(),
      websiteUrl: _websiteUrlCtrl.text.trim(),
      createdAt: widget.initial?.createdAt,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit sponsor' : 'Add sponsor'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tierCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tier (optional)',
                    helperText: 'Example: Gold / Silver / Bronze',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _logoUrlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Logo URL (optional)',
                    helperText:
                        'Tip: upload in Admin → Gallery and paste the URL.',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _websiteUrlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Website URL (optional)',
                  ),
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
