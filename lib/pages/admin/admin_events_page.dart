import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../models/club_event.dart';
import '../../widgets/admin/admin_access_gate.dart';
import '../../widgets/admin/confirm_delete_dialog.dart';
import '../../widgets/admin/forms/event_form_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class AdminEventsPage extends StatelessWidget {
  const AdminEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);

    return AdminAccessGate(
      child: Column(
        children: [
          SectionHeader(
            title: 'Events',
            trailing: FilledButton.icon(
              onPressed: () async {
                final result = await showDialog<ClubEvent>(
                  context: context,
                  builder: (context) => const EventFormDialog(),
                );
                if (result == null) return;
                await deps.eventsRepository.create(result);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ClubEvent>>(
              stream: deps.eventsRepository.streamUpcoming(limit: 200),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <ClubEvent>[];
                if (items.isEmpty) {
                  return const EmptyState(
                    title: 'No events',
                    subtitle: 'Add upcoming tournaments and events here.',
                    icon: Icons.event_outlined,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final event = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          event.title.isEmpty ? '(Empty title)' : event.title,
                        ),
                        subtitle: Text(
                          event.location.isEmpty
                              ? 'Location: (not set)'
                              : 'Location: ${event.location}',
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () async {
                                final result = await showDialog<ClubEvent>(
                                  context: context,
                                  builder: (context) =>
                                      EventFormDialog(initial: event),
                                );
                                if (result == null) return;
                                await deps.eventsRepository.update(result);
                              },
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  entityLabel: 'event "${event.title}"',
                                );
                                if (!confirmed) return;
                                await deps.eventsRepository.delete(event.id);
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
