import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../models/staff_member.dart';
import '../../utils/app_localizations.dart';
import '../../widgets/admin/admin_access_gate.dart';
import '../../widgets/admin/confirm_delete_dialog.dart';
import '../../widgets/admin/forms/staff_form_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class AdminStaffPage extends StatelessWidget {
  const AdminStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    String tr(String key) => AppLocalizations.t(context, key);

    return AdminAccessGate(
      child: Column(
        children: [
          SectionHeader(
            title: tr('staffAdmin'),
            trailing: FilledButton.icon(
              onPressed: () async {
                final result = await showDialog<StaffMember>(
                  context: context,
                  builder: (context) => const StaffFormDialog(),
                );
                if (result == null) return;
                await deps.staffRepository.create(result);
              },
              icon: const Icon(Icons.add),
              label: Text(tr('add')),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<StaffMember>>(
              stream: deps.staffRepository.streamAll(),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <StaffMember>[];
                if (items.isEmpty) {
                  return EmptyState(
                    title: tr('noStaffAdmin'),
                    subtitle: tr('staffAdminSubtitle'),
                    icon: Icons.badge_outlined,
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
                          item.fullName.isEmpty ? tr('noTitle') : item.fullName,
                        ),
                        subtitle: Text(
                          item.position.isEmpty
                              ? tr('positionOptional')
                              : '${tr('positionOptional')}: ${item.position}',
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: tr('edit'),
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () async {
                                final result = await showDialog<StaffMember>(
                                  context: context,
                                  builder: (context) =>
                                      StaffFormDialog(initial: item),
                                );
                                if (result == null) return;
                                await deps.staffRepository.update(result);
                              },
                            ),
                            IconButton(
                              tooltip: tr('delete'),
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  entityLabel:
                                      '${tr('staffEntityLabel')} "${item.fullName}"',
                                );
                                if (!confirmed) return;
                                await deps.staffRepository.delete(item.id);
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
