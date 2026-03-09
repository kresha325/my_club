import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_localizations.dart';
import '../../utils/app_nav.dart';
import '../../widgets/admin/admin_access_gate.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.t(context, key);

    final items = <({String label, IconData icon, String route})>[
      (
        label: tr('athletes'),
        icon: Icons.groups_outlined,
        route: AppNav.adminAthletesRoute,
      ),
      (
        label: tr('news'),
        icon: Icons.feed_outlined,
        route: AppNav.adminNewsRoute,
      ),
      (
        label: tr('events'),
        icon: Icons.event_outlined,
        route: AppNav.adminEventsRoute,
      ),
      (
        label: tr('matches'),
        icon: Icons.sports_soccer_outlined,
        route: AppNav.adminMatchesRoute,
      ),
      (
        label: tr('gallery'),
        icon: Icons.photo_library_outlined,
        route: AppNav.adminGalleryRoute,
      ),
      (
        label: tr('sponsors'),
        icon: Icons.handshake_outlined,
        route: AppNav.adminSponsorsRoute,
      ),
      (
        label: tr('ads'),
        icon: Icons.campaign_outlined,
        route: AppNav.adminAdsRoute,
      ),
      (
        label: tr('autopost'),
        icon: Icons.send_outlined,
        route: AppNav.adminAutopostRoute,
      ),
      (
        label: tr('training'),
        icon: Icons.fitness_center_outlined,
        route: AppNav.adminTrainingRoute,
      ),
      (
        label: tr('chat'),
        icon: Icons.forum_outlined,
        route: AppNav.adminChatRoute,
      ),
    ];

    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 1100
        ? 4
        : width >= 800
        ? 3
        : 2;

    return AdminAccessGate(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            tr('adminDashboard'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(tr('adminDashboardTip')),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: 120,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.go(item.route),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(item.icon, size: 30),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.label,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
