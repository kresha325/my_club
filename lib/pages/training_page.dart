import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app/dependencies.dart';
import '../models/training_session.dart';
import '../utils/app_localizations.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    String tr(String key) => AppLocalizations.t(context, key);

    return Column(
      children: [
        SectionHeader(title: tr('trainingSchedule')),
        Expanded(
          child: StreamBuilder<List<TrainingSession>>(
            stream: deps.trainingSessionsRepository.streamUpcoming(limit: 200),
            builder: (context, snapshot) {
              final sessions = snapshot.data ?? const <TrainingSession>[];
              if (sessions.isEmpty) {
                return EmptyState(
                  title: tr('noTrainingYet'),
                  subtitle: tr('trainingEmptySubtitle'),
                  icon: Icons.fitness_center_outlined,
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: sessions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = sessions[index];
                  final date = _formatRange(item.startAt, item.endAt);

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.fitness_center_outlined),
                      title: Text(
                        item.title.isEmpty ? '(No title)' : item.title,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (date.isNotEmpty) Text(date),
                          if (item.location.isNotEmpty)
                            Text('${tr('trainingLocation')}: ${item.location}'),
                          if (item.coach.isNotEmpty)
                            Text('${tr('trainingCoach')}: ${item.coach}'),
                          if (item.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(item.description),
                          ],
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
    );
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
