import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/training_session.dart';
import '../../../utils/app_localizations.dart';
import '../../../utils/date_time_picker.dart';
import '../../../utils/validators.dart';

class TrainingSessionFormDialog extends StatefulWidget {
  const TrainingSessionFormDialog({this.initial, super.key});

  final TrainingSession? initial;

  @override
  State<TrainingSessionFormDialog> createState() =>
      _TrainingSessionFormDialogState();
}

class _TrainingSessionFormDialogState extends State<TrainingSessionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _coachCtrl;

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
    _coachCtrl = TextEditingController(text: widget.initial?.coach ?? '');
    _startAt = widget.initial?.startAt;
    _endAt = widget.initial?.endAt;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _locationCtrl.dispose();
    _coachCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return AppLocalizations.t(context, 'notSet');
    return DateFormat.yMMMd().add_Hm().format(dt.toLocal());
  }

  Future<void> _pickStart() async {
    final picked = await pickDateTime(
      context,
      initial: _startAt,
      helpText: AppLocalizations.t(context, 'trainingStartHelp'),
    );
    if (picked == null) return;
    setState(() => _startAt = picked);
  }

  Future<void> _pickEnd() async {
    final picked = await pickDateTime(
      context,
      initial: _endAt,
      helpText: AppLocalizations.t(context, 'trainingEndHelp'),
    );
    if (picked == null) return;
    setState(() => _endAt = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final result = TrainingSession(
      id: widget.initial?.id ?? '',
      title: _titleCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      startAt: _startAt,
      endAt: _endAt,
      coach: _coachCtrl.text.trim(),
      createdAt: widget.initial?.createdAt,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    String tr(String key) => AppLocalizations.t(context, key);

    return AlertDialog(
      title: Text(
        isEdit ? tr('editTrainingSession') : tr('addTrainingSession'),
      ),
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
                TextFormField(
                  controller: _coachCtrl,
                  decoration: InputDecoration(labelText: tr('coachOptional')),
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
                TextFormField(
                  controller: _descriptionCtrl,
                  decoration: InputDecoration(
                    labelText: tr('descriptionOptional'),
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
          child: Text(tr('cancel')),
        ),
        FilledButton(onPressed: _save, child: Text(tr('save'))),
      ],
    );
  }
}
