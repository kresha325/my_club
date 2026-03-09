import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../models/ad.dart';
import '../../widgets/admin/admin_access_gate.dart';
import '../../widgets/admin/confirm_delete_dialog.dart';
import '../../widgets/admin/forms/ad_form_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class AdminAdsPage extends StatelessWidget {
  const AdminAdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);

    return AdminAccessGate(
      child: Column(
        children: [
          SectionHeader(
            title: 'Ads',
            trailing: FilledButton.icon(
              onPressed: () async {
                final result = await showDialog<Ad>(
                  context: context,
                  builder: (context) => const AdFormDialog(),
                );
                if (result == null) return;
                await deps.adsRepository.create(result);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Ad>>(
              stream: deps.adsRepository.streamAll(limit: 200),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <Ad>[];
                if (items.isEmpty) {
                  return const EmptyState(
                    title: 'No ads',
                    subtitle:
                        'Add ads/sponsor banners for monetization placeholders.\n'
                        'Developer: integrate Google AdMob or your ad server later.',
                    icon: Icons.campaign_outlined,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final ad = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          ad.title.isEmpty ? '(Empty title)' : ad.title,
                        ),
                        subtitle: Text(
                          [
                            if (ad.placement.isNotEmpty)
                              'Placement: ${ad.placement}',
                            'Active: ${ad.isActive ? 'Yes' : 'No'}',
                          ].join(' • '),
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () async {
                                final result = await showDialog<Ad>(
                                  context: context,
                                  builder: (context) =>
                                      AdFormDialog(initial: ad),
                                );
                                if (result == null) return;
                                await deps.adsRepository.update(result);
                              },
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  entityLabel: 'ad "${ad.title}"',
                                );
                                if (!confirmed) return;
                                await deps.adsRepository.delete(ad.id);
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
