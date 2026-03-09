import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/ad.dart';
import '../../../utils/date_time_picker.dart';
import '../../../utils/validators.dart';

class AdFormDialog extends StatefulWidget {
  const AdFormDialog({this.initial, super.key});

  final Ad? initial;

  @override
  State<AdFormDialog> createState() => _AdFormDialogState();
}

class _AdFormDialogState extends State<AdFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _imageUrlCtrl;
  late final TextEditingController _clickUrlCtrl;
  late final TextEditingController _placementCtrl;
  bool _isActive = false;
  DateTime? _startsAt;
  DateTime? _endsAt;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _imageUrlCtrl = TextEditingController(text: widget.initial?.imageUrl ?? '');
    _clickUrlCtrl = TextEditingController(text: widget.initial?.clickUrl ?? '');
    _placementCtrl = TextEditingController(
      text: widget.initial?.placement ?? 'home',
    );
    _isActive = widget.initial?.isActive ?? false;
    _startsAt = widget.initial?.startsAt;
    _endsAt = widget.initial?.endsAt;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _imageUrlCtrl.dispose();
    _clickUrlCtrl.dispose();
    _placementCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return 'Not set';
    return DateFormat.yMMMd().add_Hm().format(dt.toLocal());
  }

  Future<void> _pickStartsAt() async {
    final picked = await pickDateTime(
      context,
      initial: _startsAt,
      helpText: 'Starts at',
    );
    if (picked == null) return;
    setState(() => _startsAt = picked);
  }

  Future<void> _pickEndsAt() async {
    final picked = await pickDateTime(
      context,
      initial: _endsAt,
      helpText: 'Ends at',
    );
    if (picked == null) return;
    setState(() => _endsAt = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final result = Ad(
      id: widget.initial?.id ?? '',
      title: _titleCtrl.text.trim(),
      imageUrl: _imageUrlCtrl.text.trim(),
      clickUrl: _clickUrlCtrl.text.trim(),
      placement: _placementCtrl.text.trim(),
      isActive: _isActive,
      startsAt: _startsAt,
      endsAt: _endsAt,
      createdAt: widget.initial?.createdAt,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit ad' : 'Add ad'),
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
                  controller: _placementCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Placement (optional)',
                    helperText:
                        'Example: home_top, sponsors_page, results_bottom',
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Active'),
                  value: _isActive,
                  onChanged: (v) => setState(() => _isActive = v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _imageUrlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Image URL (optional)',
                    helperText:
                        'Tip: upload in Admin → Gallery and paste the URL.',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _clickUrlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Click URL (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Text('Starts: ${_fmt(_startsAt)}')),
                    TextButton.icon(
                      onPressed: _pickStartsAt,
                      icon: const Icon(Icons.schedule),
                      label: const Text('Pick'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text('Ends: ${_fmt(_endsAt)}')),
                    TextButton.icon(
                      onPressed: _pickEndsAt,
                      icon: const Icon(Icons.schedule),
                      label: const Text('Pick'),
                    ),
                  ],
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
