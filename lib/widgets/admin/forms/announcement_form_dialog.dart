import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/announcement.dart';
import '../../../utils/app_localizations.dart';
import '../../../utils/date_time_picker.dart';
import '../../../utils/validators.dart';

class AnnouncementFormDialog extends StatefulWidget {
  const AnnouncementFormDialog({this.initial, super.key});

  final Announcement? initial;

  @override
  State<AnnouncementFormDialog> createState() => _AnnouncementFormDialogState();
}

class _AnnouncementFormDialogState extends State<AnnouncementFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _messageCtrl;
  bool _requiresParticipation = false;
  DateTime? _startsAt;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _messageCtrl = TextEditingController(text: widget.initial?.message ?? '');
    _requiresParticipation = widget.initial?.requiresParticipation ?? false;
    _startsAt = widget.initial?.startsAt;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _messageCtrl.dispose();
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
      helpText: AppLocalizations.t(context, 'announcementStartHelp'),
    );
    if (picked == null) return;
    setState(() => _startsAt = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final result = Announcement(
      id: widget.initial?.id ?? '',
      title: _titleCtrl.text.trim(),
      message: _messageCtrl.text.trim(),
      createdAt: widget.initial?.createdAt,
      startsAt: _startsAt,
      requiresParticipation: _requiresParticipation,
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    String tr(String key) => AppLocalizations.t(context, key);

    return AlertDialog(
      title: Text(isEdit ? tr('editAnnouncement') : tr('addAnnouncement')),
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
                Row(
                  children: [
                    Expanded(
                      child: Text('${tr('startsAt')}: ${_fmt(_startsAt)}'),
                    ),
                    TextButton.icon(
                      onPressed: _pickStartsAt,
                      icon: const Icon(Icons.schedule),
                      label: Text(tr('pick')),
                    ),
                  ],
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(tr('requireParticipation')),
                  subtitle: Text(tr('requireParticipationSubtitle')),
                  value: _requiresParticipation,
                  onChanged: (value) =>
                      setState(() => _requiresParticipation = value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _messageCtrl,
                  decoration: InputDecoration(labelText: tr('message')),
                  validator: Validators.requiredField,
                  maxLines: 6,
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
