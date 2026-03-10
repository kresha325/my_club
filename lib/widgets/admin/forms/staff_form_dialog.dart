import 'package:flutter/material.dart';

import '../../../models/staff_member.dart';
import '../../../utils/app_localizations.dart';
import '../../../utils/validators.dart';

class StaffFormDialog extends StatefulWidget {
  const StaffFormDialog({this.initial, super.key});

  final StaffMember? initial;

  @override
  State<StaffFormDialog> createState() => _StaffFormDialogState();
}

class _StaffFormDialogState extends State<StaffFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _positionCtrl;
  late final TextEditingController _photoUrlCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.fullName ?? '');
    _positionCtrl = TextEditingController(text: widget.initial?.position ?? '');
    _photoUrlCtrl = TextEditingController(text: widget.initial?.photoUrl ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _positionCtrl.dispose();
    _photoUrlCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final result = StaffMember(
      id: widget.initial?.id ?? '',
      fullName: _nameCtrl.text.trim(),
      position: _positionCtrl.text.trim(),
      photoUrl: _photoUrlCtrl.text.trim(),
      createdAt: widget.initial?.createdAt,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    String tr(String key) => AppLocalizations.t(context, key);

    return AlertDialog(
      title: Text(isEdit ? tr('editStaff') : tr('addStaff')),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(labelText: tr('fullName')),
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _positionCtrl,
                  decoration: InputDecoration(
                    labelText: tr('positionOptional'),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _photoUrlCtrl,
                  decoration: InputDecoration(
                    labelText: tr('photoUrlOptional'),
                    helperText: tr('galleryUrlTip'),
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
          child: Text(tr('cancel')),
        ),
        FilledButton(onPressed: _save, child: Text(tr('save'))),
      ],
    );
  }
}
