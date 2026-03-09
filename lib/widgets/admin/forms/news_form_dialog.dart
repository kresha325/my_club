import 'package:flutter/material.dart';

import '../../../models/news_item.dart';
import '../../../utils/validators.dart';

class NewsFormDialog extends StatefulWidget {
  const NewsFormDialog({this.initial, super.key});

  final NewsItem? initial;

  @override
  State<NewsFormDialog> createState() => _NewsFormDialogState();
}

class _NewsFormDialogState extends State<NewsFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;
  late final TextEditingController _coverUrlCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _bodyCtrl = TextEditingController(text: widget.initial?.body ?? '');
    _coverUrlCtrl = TextEditingController(text: widget.initial?.coverUrl ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _coverUrlCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();

    final result = NewsItem(
      id: widget.initial?.id ?? '',
      title: _titleCtrl.text.trim(),
      body: _bodyCtrl.text.trim(),
      coverUrl: _coverUrlCtrl.text.trim(),
      publishedAt: widget.initial?.publishedAt ?? now,
      createdAt: widget.initial?.createdAt,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit news' : 'Add news'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
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
                  controller: _coverUrlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Cover image URL (optional)',
                    helperText:
                        'Tip: upload in Admin → Gallery and paste the URL.',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bodyCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Body (optional)',
                    helperText: 'Keep blank for now; admin can fill later.',
                  ),
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
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
