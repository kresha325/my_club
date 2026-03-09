import 'package:flutter/material.dart';

Future<DateTime?> pickDateTime(
  BuildContext context, {
  DateTime? initial,
  String? helpText,
}) async {
  final now = DateTime.now();
  final initialDate = initial ?? now;

  final date = await showDatePicker(
    context: context,
    initialDate: DateTime(initialDate.year, initialDate.month, initialDate.day),
    firstDate: DateTime(now.year - 3),
    lastDate: DateTime(now.year + 10),
    helpText: helpText,
  );
  if (date == null) return null;
  if (!context.mounted) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
    helpText: helpText,
  );
  if (time == null) return null;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
