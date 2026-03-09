import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../models/club_match.dart';
import '../../widgets/admin/admin_access_gate.dart';
import '../../widgets/admin/confirm_delete_dialog.dart';
import '../../widgets/admin/forms/match_form_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class AdminMatchesPage extends StatelessWidget {
  const AdminMatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);

    return AdminAccessGate(
      child: Column(
        children: [
          SectionHeader(
            title: 'Matches',
            trailing: FilledButton.icon(
              onPressed: () async {
                final result = await showDialog<ClubMatch>(
                  context: context,
                  builder: (_) => const MatchFormDialog(),
                );
                if (result == null) return;
                await deps.matchesRepository.create(result);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ClubMatch>>(
              stream: deps.matchesRepository.streamLatest(limit: 200),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <ClubMatch>[];
                if (items.isEmpty) {
                  return const EmptyState(
                    title: 'No matches',
                    subtitle: 'Add matches and scores for the Results page.',
                    icon: Icons.sports_soccer_outlined,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final match = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          match.opponent.isEmpty
                              ? '(Opponent TBD)'
                              : match.opponent,
                        ),
                        subtitle: Text(
                          match.competition.isEmpty
                              ? 'Competition: (not set)'
                              : 'Competition: ${match.competition}',
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () async {
                                final result = await showDialog<ClubMatch>(
                                  context: context,
                                  builder: (_) =>
                                      MatchFormDialog(initial: match),
                                );
                                if (result == null) return;
                                await deps.matchesRepository.update(result);
                              },
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  entityLabel: 'match vs "${match.opponent}"',
                                );
                                if (!confirmed) return;
                                await deps.matchesRepository.delete(match.id);
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
