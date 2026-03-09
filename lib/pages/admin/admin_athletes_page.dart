import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../models/athlete.dart';
import '../../widgets/admin/admin_access_gate.dart';
import '../../widgets/admin/confirm_delete_dialog.dart';
import '../../widgets/admin/forms/athlete_form_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class AdminAthletesPage extends StatelessWidget {
  const AdminAthletesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);

    return AdminAccessGate(
      child: Column(
        children: [
          SectionHeader(
            title: 'Athletes',
            trailing: FilledButton.icon(
              onPressed: () async {
                final result = await showDialog<Athlete>(
                  context: context,
                  builder: (_) => const AthleteFormDialog(),
                );
                if (result == null) return;
                await deps.athletesRepository.create(result);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Athlete>>(
              stream: deps.athletesRepository.streamAll(),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <Athlete>[];
                if (items.isEmpty) {
                  return const EmptyState(
                    title: 'No athletes',
                    subtitle: 'Add athletes so the Team page can display them.',
                    icon: Icons.groups_outlined,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final athlete = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          athlete.fullName.isEmpty
                              ? '(Empty name)'
                              : athlete.fullName,
                        ),
                        subtitle: Text(
                          athlete.position.isEmpty
                              ? 'Position: (not set)'
                              : 'Position: ${athlete.position}',
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () async {
                                final result = await showDialog<Athlete>(
                                  context: context,
                                  builder: (_) =>
                                      AthleteFormDialog(initial: athlete),
                                );
                                if (result == null) return;
                                await deps.athletesRepository.update(result);
                              },
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  entityLabel: 'athlete "${athlete.fullName}"',
                                );
                                if (!confirmed) return;
                                await deps.athletesRepository.delete(
                                  athlete.id,
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
}
