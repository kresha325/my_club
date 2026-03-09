import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../models/sponsor.dart';
import '../../widgets/admin/admin_access_gate.dart';
import '../../widgets/admin/confirm_delete_dialog.dart';
import '../../widgets/admin/forms/sponsor_form_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class AdminSponsorsPage extends StatelessWidget {
  const AdminSponsorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);

    return AdminAccessGate(
      child: Column(
        children: [
          SectionHeader(
            title: 'Sponsors',
            trailing: FilledButton.icon(
              onPressed: () async {
                final result = await showDialog<Sponsor>(
                  context: context,
                  builder: (context) => const SponsorFormDialog(),
                );
                if (result == null) return;
                await deps.sponsorsRepository.create(result);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Sponsor>>(
              stream: deps.sponsorsRepository.streamAll(),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <Sponsor>[];
                if (items.isEmpty) {
                  return const EmptyState(
                    title: 'No sponsors',
                    subtitle:
                        'Add sponsors to show on the public Sponsors page.',
                    icon: Icons.handshake_outlined,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final sponsor = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          sponsor.name.isEmpty ? '(Empty name)' : sponsor.name,
                        ),
                        subtitle: Text(
                          sponsor.tier.isEmpty
                              ? 'Tier: (not set)'
                              : 'Tier: ${sponsor.tier}',
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () async {
                                final result = await showDialog<Sponsor>(
                                  context: context,
                                  builder: (context) =>
                                      SponsorFormDialog(initial: sponsor),
                                );
                                if (result == null) return;
                                await deps.sponsorsRepository.update(result);
                              },
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  entityLabel: 'sponsor "${sponsor.name}"',
                                );
                                if (!confirmed) return;
                                await deps.sponsorsRepository.delete(
                                  sponsor.id,
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
