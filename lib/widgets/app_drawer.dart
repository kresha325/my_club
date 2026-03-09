import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_constants.dart';
import '../utils/app_nav.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            const ListTile(
              title: Text(AppConstants.appName),
              subtitle: Text('White-label club skeleton'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.card_membership_outlined),
              title: const Text('Membership'),
              onTap: () => context.go(AppNav.membershipRoute),
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: const Text('Admin'),
              onTap: () => context.go(AppNav.adminHomeRoute),
            ),
          ],
        ),
      ),
    );
  }
}
