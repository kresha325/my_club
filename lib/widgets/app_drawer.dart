import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_constants.dart';
import '../utils/app_localizations.dart';
import '../utils/app_nav.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.t(context, key);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            ListTile(
              leading: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset(
                  AppConstants.clubLogoAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.sports_martial_arts_outlined),
                ),
              ),
              title: Text(AppConstants.appName),
              subtitle: Text(tr('appSubtitle')),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(tr('aboutClub')),
              onTap: () => context.go(AppNav.aboutRoute),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center_outlined),
              title: Text(tr('trainingSchedule')),
              onTap: () => context.go(AppNav.trainingRoute),
            ),
            ListTile(
              leading: const Icon(Icons.forum_outlined),
              title: Text(tr('clubChat')),
              onTap: () => context.go(AppNav.clubChatRoute),
            ),
            ListTile(
              leading: const Icon(Icons.card_membership_outlined),
              title: Text(tr('membership')),
              onTap: () => context.go(AppNav.membershipRoute),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: Text(tr('admin')),
              onTap: () => context.go(AppNav.adminHomeRoute),
            ),
          ],
        ),
      ),
    );
  }
}
