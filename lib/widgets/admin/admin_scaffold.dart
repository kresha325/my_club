import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/dependencies.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_nav.dart';

class AdminScaffold extends StatelessWidget {
  const AdminScaffold({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    final destinations = AppNav.adminDestinations;
    final selectedIndex = AppNav.indexForLocation(
      location: location,
      destinations: destinations,
    );
    final isWide = MediaQuery.of(context).size.width >= 980;

    return Scaffold(
      appBar: AppBar(
        title: const Text('${AppConstants.appName} — Admin'),
        actions: [
          IconButton(
            tooltip: 'Back to public app',
            onPressed: () => context.go(AppNav.homeRoute),
            icon: const Icon(Icons.public),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: () async {
              await deps.authService.signOut();
              if (context.mounted) context.go(AppNav.homeRoute);
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          if (isWide)
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
            )
          else
            const SizedBox.shrink(),
          if (isWide) const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
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
