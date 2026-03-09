import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_nav.dart';
import '../../widgets/admin/admin_access_gate.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <({String label, IconData icon, String route})>[
      (
        label: 'Athletes',
        icon: Icons.groups_outlined,
        route: AppNav.adminAthletesRoute,
      ),
      (label: 'News', icon: Icons.feed_outlined, route: AppNav.adminNewsRoute),
      (
        label: 'Events',
        icon: Icons.event_outlined,
        route: AppNav.adminEventsRoute,
      ),
      (
        label: 'Matches',
        icon: Icons.sports_soccer_outlined,
        route: AppNav.adminMatchesRoute,
      ),
      (
        label: 'Gallery',
        icon: Icons.photo_library_outlined,
        route: AppNav.adminGalleryRoute,
      ),
      (
        label: 'Sponsors',
        icon: Icons.handshake_outlined,
        route: AppNav.adminSponsorsRoute,
      ),
      (
        label: 'Ads',
        icon: Icons.campaign_outlined,
        route: AppNav.adminAdsRoute,
      ),
      (
        label: 'Autopost',
        icon: Icons.send_outlined,
        route: AppNav.adminAutopostRoute,
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
            'Admin Dashboard',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'Everything starts empty. Use these sections to populate the club app.\n\n'
            'Tip: Upload media first (Gallery), then reference URLs in News/Events/Sponsors/Ads.',
          ),
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
