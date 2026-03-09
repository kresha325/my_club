import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../models/announcement.dart';
import '../../utils/app_localizations.dart';
import '../../widgets/admin/admin_access_gate.dart';
import '../../widgets/admin/confirm_delete_dialog.dart';
import '../../widgets/admin/forms/announcement_form_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class AdminChatPage extends StatelessWidget {
  const AdminChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    String tr(String key) => AppLocalizations.t(context, key);

    return AdminAccessGate(
      child: Column(
        children: [
          SectionHeader(
            title: tr('adminBroadcastChat'),
            trailing: FilledButton.icon(
              onPressed: () async {
                final result = await showDialog<Announcement>(
                  context: context,
                  builder: (context) => const AnnouncementFormDialog(),
                );
                if (result == null) return;
                await deps.announcementsRepository.create(result);
              },
              icon: const Icon(Icons.add),
              label: Text(tr('addMessage')),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Announcement>>(
              stream: deps.announcementsRepository.streamLatest(limit: 300),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <Announcement>[];
                if (items.isEmpty) {
                  return EmptyState(
                    title: tr('noAdminMessages'),
                    subtitle: tr('noAdminMessagesSubtitle'),
                    icon: Icons.campaign_outlined,
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
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title.isEmpty
                                        ? tr('noTitle')
                                        : item.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                                IconButton(
                                  tooltip: tr('edit'),
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () async {
                                    final result =
                                        await showDialog<Announcement>(
                                          context: context,
                                          builder: (context) =>
                                              AnnouncementFormDialog(
                                                initial: item,
                                              ),
                                        );
                                    if (result == null) return;
                                    await deps.announcementsRepository.update(
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
                                          '${tr('announcementEntityLabel')} "${item.title}"',
                                    );
                                    if (!confirmed) return;
                                    await deps.announcementsRepository.delete(
                                      item.id,
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(item.message),
                            if (item.requiresParticipation) ...[
                              const SizedBox(height: 8),
                              Text(
                                tr('participationConfirmationActive'),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 6),
                              StreamBuilder<List<AnnouncementResponse>>(
                                stream: deps.announcementsRepository
                                    .streamResponses(item.id),
                                builder: (context, snapshot) {
                                  final responses =
                                      snapshot.data ??
                                      const <AnnouncementResponse>[];
                                  final yesCount = responses
                                      .where(
                                        (r) =>
                                            r.choice == ParticipationChoice.yes,
                                      )
                                      .length;
                                  final noCount = responses
                                      .where(
                                        (r) =>
                                            r.choice == ParticipationChoice.no,
                                      )
                                      .length;

                                  final named = responses
                                      .map((r) => r.displayName.trim())
                                      .where((name) => name.isNotEmpty)
                                      .toSet()
                                      .toList();

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${tr('responses')}: $yesCount ${tr('iWillParticipate')} | $noCount ${tr('iWillNotParticipate')}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      if (named.isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: [
                                            for (final name in named)
                                              Chip(
                                                label: Text(name),
                                                visualDensity:
                                                    VisualDensity.compact,
                                              ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
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
      ),
    );
  }
}
