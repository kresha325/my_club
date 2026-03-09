import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../models/autopost_job.dart';
import '../../widgets/admin/admin_access_gate.dart';
import '../../widgets/admin/confirm_delete_dialog.dart';
import '../../widgets/admin/forms/autopost_job_form_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class AdminAutopostPage extends StatelessWidget {
  const AdminAutopostPage({super.key});

  Future<void> _triggerNow(
    BuildContext context,
    AppDependencies deps,
    AutopostJob job,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      for (final platform in job.platforms) {
        await deps.autopostService.autopostNow(
          platform: platform,
          contentType: job.contentType,
          contentId: job.contentId,
        );
      }
      messenger.showSnackBar(
        const SnackBar(content: Text('Autopost trigger sent (placeholder).')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Autopost failed (expected until deployed): $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);

    return AdminAccessGate(
      child: Column(
        children: [
          SectionHeader(
            title: 'Autopost (YouTube / Instagram / Facebook)',
            trailing: FilledButton.icon(
              onPressed: () async {
                final job = await showDialog<AutopostJob>(
                  context: context,
                  builder: (_) => const AutopostJobFormDialog(),
                );
                if (job == null) return;
                await deps.autopostJobsRepository.create(job);
              },
              icon: const Icon(Icons.add),
              label: const Text('New job'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<AutopostJob>>(
              stream: deps.autopostJobsRepository.streamRecent(limit: 200),
              builder: (context, snapshot) {
                final jobs = snapshot.data ?? const <AutopostJob>[];
                if (jobs.isEmpty) {
                  return const EmptyState(
                    title: 'No autopost jobs',
                    subtitle:
                        'Create jobs to trigger/schedule posting to social platforms.\n\n'
                        'Developer: implement real API calls in Firebase Functions.',
                    icon: Icons.send_outlined,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: jobs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.send_outlined),
                        title: Text(
                          '${job.contentType} • ${job.contentId.isEmpty ? '(missing id)' : job.contentId}',
                        ),
                        subtitle: Text(
                          [
                            'Platforms: ${job.platforms.isEmpty ? '(none)' : job.platforms.join(', ')}',
                            'Status: ${job.status.isEmpty ? 'queued' : job.status}',
                          ].join(' • '),
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: 'Trigger now',
                              icon: const Icon(Icons.flash_on_outlined),
                              onPressed: job.platforms.isEmpty
                                  ? null
                                  : () => _triggerNow(context, deps, job),
                            ),
                            IconButton(
                              tooltip: 'Delete job',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  entityLabel:
                                      'autopost job "${job.contentId}"',
                                );
                                if (!confirmed) return;
                                await deps.autopostJobsRepository.delete(
                                  job.id,
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
