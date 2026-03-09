import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/club_match.dart';
import '../../../utils/date_time_picker.dart';
import '../../../utils/validators.dart';

class MatchFormDialog extends StatefulWidget {
  const MatchFormDialog({this.initial, super.key});

  final ClubMatch? initial;

  @override
  State<MatchFormDialog> createState() => _MatchFormDialogState();
}

class _MatchFormDialogState extends State<MatchFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _opponentCtrl;
  late final TextEditingController _competitionCtrl;
  late final TextEditingController _homeScoreCtrl;
  late final TextEditingController _awayScoreCtrl;
  late final TextEditingController _highlightsUrlCtrl;

  bool _isHome = true;
  DateTime? _matchAt;

  @override
  void initState() {
    super.initState();
    _opponentCtrl = TextEditingController(text: widget.initial?.opponent ?? '');
    _competitionCtrl = TextEditingController(
      text: widget.initial?.competition ?? '',
    );
    _homeScoreCtrl = TextEditingController(
      text: widget.initial?.homeScore?.toString() ?? '',
    );
    _awayScoreCtrl = TextEditingController(
      text: widget.initial?.awayScore?.toString() ?? '',
    );
    _highlightsUrlCtrl = TextEditingController(
      text: widget.initial?.highlightsUrl ?? '',
    );
    _isHome = widget.initial?.isHome ?? true;
    _matchAt = widget.initial?.matchAt;
  }

  @override
  void dispose() {
    _opponentCtrl.dispose();
    _competitionCtrl.dispose();
    _homeScoreCtrl.dispose();
    _awayScoreCtrl.dispose();
    _highlightsUrlCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return 'Not set';
    return DateFormat.yMMMd().add_Hm().format(dt.toLocal());
  }

  Future<void> _pickMatchAt() async {
    final picked = await pickDateTime(
      context,
      initial: _matchAt,
      helpText: 'Match date',
    );
    if (picked == null) return;
    setState(() => _matchAt = picked);
  }

  int? _tryParseInt(String value) => int.tryParse(value.trim());

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final result = ClubMatch(
      id: widget.initial?.id ?? '',
      opponent: _opponentCtrl.text.trim(),
      competition: _competitionCtrl.text.trim(),
      isHome: _isHome,
      homeScore: _tryParseInt(_homeScoreCtrl.text),
      awayScore: _tryParseInt(_awayScoreCtrl.text),
      matchAt: _matchAt,
      highlightsUrl: _highlightsUrlCtrl.text.trim(),
      createdAt: widget.initial?.createdAt,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit match' : 'Add match'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _opponentCtrl,
                  decoration: const InputDecoration(labelText: 'Opponent'),
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _competitionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Competition (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Home match'),
                  value: _isHome,
                  onChanged: (v) => setState(() => _isHome = v),
                ),
                Row(
                  children: [
                    Expanded(child: Text('Match date: ${_fmt(_matchAt)}')),
                    TextButton.icon(
                      onPressed: _pickMatchAt,
                      icon: const Icon(Icons.schedule),
                      label: const Text('Pick'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _homeScoreCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Home score (optional)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _awayScoreCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Away score (optional)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _highlightsUrlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Highlights URL (optional)',
                    helperText: 'YouTube / Facebook video link placeholder.',
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
