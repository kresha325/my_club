import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_constants.dart';
import '../utils/app_nav.dart';
import 'app_drawer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final destinations = AppNav.publicDestinations;
    final selectedIndex = AppNav.indexForLocation(
      location: location,
      destinations: destinations,
    );

    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          TextButton.icon(
            onPressed: () => context.go(AppNav.adminHomeRoute),
            icon: const Icon(Icons.admin_panel_settings_outlined),
            label: const Text('Admin'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: isWide ? null : const AppDrawer(),
      body: isWide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) =>
                      context.go(destinations[index].route),
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    for (final d in destinations)
                      NavigationRailDestination(
                        icon: Icon(d.icon),
                        label: Text(d.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            )
          : child,
      bottomNavigationBar: isWide
          ? null
          : BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) => context.go(destinations[index].route),
              type: BottomNavigationBarType.fixed,
              items: [
                for (final d in destinations)
                  BottomNavigationBarItem(icon: Icon(d.icon), label: d.label),
              ],
            ),
    );
  }
}
