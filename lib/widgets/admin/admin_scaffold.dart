import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/dependencies.dart';
import '../../app/locale_scope.dart';
import '../../app/theme_scope.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_localizations.dart';
import '../../utils/app_nav.dart';

class AdminScaffold extends StatelessWidget {
  const AdminScaffold({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.t(context, key);
    final deps = DependenciesScope.of(context);
    final themeController = ThemeScope.of(context);
    final localeController = LocaleScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final destinations = AppNav.adminDestinations;
    final showRailLabels = MediaQuery.of(context).size.height >= 860;
    final selectedIndex = AppNav.indexForLocation(
      location: location,
      destinations: destinations,
    );
    final isWide = MediaQuery.of(context).size.width >= 980;

    return Scaffold(
      appBar: AppBar(
        title: Text('${AppConstants.appName} — ${tr('admin')}'),
        actions: [
          IconButton(
            tooltip: isDark ? tr('switchToLight') : tr('switchToDark'),
            onPressed: themeController.toggleLightDark,
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
          ),
          PopupMenuButton<Locale>(
            tooltip: tr('language'),
            onSelected: localeController.setLocale,
            itemBuilder: (context) => const [
              PopupMenuItem(value: Locale('sq'), child: Text('Shqip')),
              PopupMenuItem(value: Locale('en'), child: Text('English')),
            ],
            icon: const Icon(Icons.language_outlined),
          ),
          IconButton(
            tooltip: tr('backToPublic'),
            onPressed: () => context.go(AppNav.homeRoute),
            icon: const Icon(Icons.public),
          ),
          IconButton(
            tooltip: tr('signOut'),
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
              labelType: showRailLabels
                  ? NavigationRailLabelType.all
                  : NavigationRailLabelType.none,
              minWidth: showRailLabels ? 72 : 56,
              groupAlignment: -1,
              scrollable: true,
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    label: Text(_labelForRoute(context, d.route)),
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
                  BottomNavigationBarItem(
                    icon: Icon(d.icon),
                    label: _labelForRoute(context, d.route),
                  ),
              ],
            ),
    );
  }

  String _labelForRoute(BuildContext context, String route) {
    String tr(String key) => AppLocalizations.t(context, key);
    return switch (route) {
      AppNav.adminHomeRoute => tr('dashboard'),
      AppNav.adminAthletesRoute => tr('athletes'),
      AppNav.adminNewsRoute => tr('news'),
      AppNav.adminEventsRoute => tr('events'),
      AppNav.adminMatchesRoute => tr('matches'),
      AppNav.adminGalleryRoute => tr('gallery'),
      AppNav.adminSponsorsRoute => tr('sponsors'),
      AppNav.adminAdsRoute => tr('ads'),
      AppNav.adminAutopostRoute => tr('autopost'),
      AppNav.adminTrainingRoute => tr('training'),
      AppNav.adminChatRoute => tr('chat'),
      _ => route,
    };
  }
}
