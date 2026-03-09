import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/dependencies.dart';
import '../../models/training_session.dart';
import '../../utils/app_localizations.dart';
import '../../widgets/admin/admin_access_gate.dart';
import '../../widgets/admin/confirm_delete_dialog.dart';
import '../../widgets/admin/forms/training_session_form_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class AdminTrainingPage extends StatelessWidget {
  const AdminTrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    String tr(String key) => AppLocalizations.t(context, key);

    return AdminAccessGate(
      child: Column(
        children: [
          SectionHeader(
            title: tr('trainingSessionsAdmin'),
            trailing: FilledButton.icon(
              onPressed: () async {
                final result = await showDialog<TrainingSession>(
                  context: context,
                  builder: (context) => const TrainingSessionFormDialog(),
                );
                if (result == null) return;
                await deps.trainingSessionsRepository.create(result);
              },
              icon: const Icon(Icons.add),
              label: Text(tr('add')),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<TrainingSession>>(
              stream: deps.trainingSessionsRepository.streamUpcoming(
                limit: 250,
              ),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <TrainingSession>[];
                if (items.isEmpty) {
                  return EmptyState(
                    title: tr('noTrainingSessionsAdmin'),
                    subtitle: tr('trainingAdminSubtitle'),
                    icon: Icons.fitness_center_outlined,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Card(
                      child: ListTile(
                        title: Text(
                          item.title.isEmpty ? tr('noTitle') : item.title,
                        ),
                        subtitle: Text(_subtitle(context, item)),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: tr('edit'),
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () async {
                                final result =
                                    await showDialog<TrainingSession>(
                                      context: context,
                                      builder: (context) =>
                                          TrainingSessionFormDialog(
                                            initial: item,
                                          ),
                                    );
                                if (result == null) return;
                                await deps.trainingSessionsRepository.update(
                                  result,
                                );
                              },
                            ),
                            IconButton(
                              tooltip: tr('delete'),
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  entityLabel:
                                      '${tr('trainingEntityLabel')} "${item.title}"',
                                );
                                if (!confirmed) return;
                                await deps.trainingSessionsRepository.delete(
                                  item.id,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _subtitle(BuildContext context, TrainingSession item) {
    String tr(String key) => AppLocalizations.t(context, key);
    final parts = <String>[];
    final date = _formatRange(item.startAt, item.endAt);
    if (date.isNotEmpty) parts.add(date);
    if (item.location.isNotEmpty) {
      parts.add('${tr('trainingLocation')}: ${item.location}');
    }
    if (item.coach.isNotEmpty) {
      parts.add('${tr('trainingCoach')}: ${item.coach}');
    }
    return parts.isEmpty ? tr('noDetailsYet') : parts.join(' | ');
  }

  String _formatRange(DateTime? start, DateTime? end) {
    if (start == null && end == null) return '';
    final fmt = DateFormat.yMMMd().add_Hm();
    final startText = start == null ? '' : fmt.format(start.toLocal());
    final endText = end == null ? '' : fmt.format(end.toLocal());

    if (startText.isNotEmpty && endText.isNotEmpty) {
      return '$startText - $endText';
    }
    return startText.isNotEmpty ? startText : endText;
  }
}
