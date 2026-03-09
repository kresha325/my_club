import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/ad.dart';
import '../../../utils/app_localizations.dart';
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
    if (dt == null) return AppLocalizations.t(context, 'notSet');
    return DateFormat.yMMMd().add_Hm().format(dt.toLocal());
  }

  Future<void> _pickStartsAt() async {
    final picked = await pickDateTime(
      context,
      initial: _startsAt,
      helpText: AppLocalizations.t(context, 'startsAtHelp'),
    );
    if (picked == null) return;
    setState(() => _startsAt = picked);
  }

  Future<void> _pickEndsAt() async {
    final picked = await pickDateTime(
      context,
      initial: _endsAt,
      helpText: AppLocalizations.t(context, 'endsAtHelp'),
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
    String tr(String key) => AppLocalizations.t(context, key);

    return AlertDialog(
      title: Text(isEdit ? tr('editAd') : tr('addAd')),
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
                  controller: _placementCtrl,
                  decoration: InputDecoration(
                    labelText: tr('placementOptional'),
                    helperText: tr('placementExample'),
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: Text(tr('active')),
                  value: _isActive,
                  onChanged: (v) => setState(() => _isActive = v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _imageUrlCtrl,
                  decoration: InputDecoration(
                    labelText: tr('imageUrlOptional'),
                    helperText: tr('galleryUrlTip'),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _clickUrlCtrl,
                  decoration: InputDecoration(
                    labelText: tr('clickUrlOptional'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text('${tr('starts')}: ${_fmt(_startsAt)}'),
                    ),
                    TextButton.icon(
                      onPressed: _pickStartsAt,
                      icon: const Icon(Icons.schedule),
                      label: Text(tr('pick')),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text('${tr('ends')}: ${_fmt(_endsAt)}')),
                    TextButton.icon(
                      onPressed: _pickEndsAt,
                      icon: const Icon(Icons.schedule),
                      label: Text(tr('pick')),
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
          child: Text(tr('cancel')),
        ),
        FilledButton(onPressed: _save, child: Text(tr('save'))),
      ],
    );
  }
}
