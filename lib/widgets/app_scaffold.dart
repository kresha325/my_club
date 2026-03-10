import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/locale_scope.dart';
import '../utils/app_constants.dart';
import '../utils/app_localizations.dart';
import '../utils/app_nav.dart';
import '../app/theme_scope.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.t(context, key);
    final themeController = ThemeScope.of(context);
    final localeController = LocaleScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final destinations = AppNav.publicDestinations;
    final mobilePrimaryDestinations = [
      destinations.firstWhere((d) => d.route == AppNav.homeRoute),
      destinations.firstWhere((d) => d.route == AppNav.teamRoute),
      destinations.firstWhere((d) => d.route == AppNav.eventsRoute),
    ];
    final mobileMenuDestinations = destinations
        .where((d) => !mobilePrimaryDestinations.any((p) => p.route == d.route))
        .toList();
    final isWide = screenWidth >= 900;
    final showRailLabels = MediaQuery.of(context).size.height >= 820;
    final compactActions = screenWidth < 640;
    final selectedIndex = AppNav.indexForLocation(
      location: location,
      destinations: destinations,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Image.asset(
                AppConstants.clubLogoAsset,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.sports_martial_arts_outlined, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstants.appName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    tr('appSubtitle'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: isWide
            ? [
                IconButton(
                  tooltip: isDark ? tr('switchToLight') : tr('switchToDark'),
                  onPressed: themeController.toggleLightDark,
                  icon: Icon(
                    isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
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
                if (compactActions)
                  IconButton(
                    tooltip: tr('admin'),
                    onPressed: () => context.go(AppNav.adminHomeRoute),
                    icon: const Icon(Icons.admin_panel_settings_outlined),
                  )
                else
                  TextButton.icon(
                    onPressed: () => context.go(AppNav.adminHomeRoute),
                    icon: const Icon(Icons.admin_panel_settings_outlined),
                    label: Text(tr('admin')),
                  ),
                const SizedBox(width: 4),
              ]
            : null,
      ),
      body: isWide
          ? Row(
              children: [
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
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            )
          : child,
      bottomNavigationBar: isWide
          ? null
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _mobileSelectedIndex(
                location,
                mobilePrimaryDestinations,
              ),
              onTap: (index) async {
                if (index < mobilePrimaryDestinations.length) {
                  context.go(mobilePrimaryDestinations[index].route);
                  return;
                }
                if (index == mobilePrimaryDestinations.length) {
                  final selectedRoute = await showModalBottomSheet<String>(
                    context: context,
                    showDragHandle: true,
                    builder: (sheetContext) => SafeArea(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (final d in mobileMenuDestinations)
                            ListTile(
                              leading: Icon(d.icon),
                              title: Text(_labelForRoute(context, d.route)),
                              onTap: () =>
                                  Navigator.of(sheetContext).pop(d.route),
                            ),
                        ],
                      ),
                    ),
                  );
                  if (selectedRoute != null && context.mounted) {
                    context.go(selectedRoute);
                  }
                  return;
                }

                await showModalBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  builder: (sheetContext) => SafeArea(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          leading: Icon(
                            isDark
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                          ),
                          title: Text(
                            isDark ? tr('switchToLight') : tr('switchToDark'),
                          ),
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            themeController.toggleLightDark();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.language_outlined),
                          title: Text(tr('language')),
                          subtitle: const Text('Shqip / English'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.flag_outlined),
                          title: const Text('Shqip'),
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            localeController.setLocale(const Locale('sq'));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.language_outlined),
                          title: const Text('English'),
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            localeController.setLocale(const Locale('en'));
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.admin_panel_settings_outlined,
                          ),
                          title: Text(tr('admin')),
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            context.go(AppNav.adminHomeRoute);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              items: [
                for (final d in mobilePrimaryDestinations)
                  BottomNavigationBarItem(
                    icon: Icon(d.icon),
                    label: _labelForRoute(context, d.route),
                  ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.menu_outlined),
                  label: tr('menu'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_outlined),
                  label: tr('settings'),
                ),
              ],
            ),
    );
  }

  int _mobileSelectedIndex(String location, List<NavDestination> primary) {
    final primaryIndex = primary.indexWhere((d) => location == d.route);
    if (primaryIndex >= 0) {
      return primaryIndex;
    }
    return primary.length;
  }

  String _labelForRoute(BuildContext context, String route) {
    String tr(String key) => AppLocalizations.t(context, key);
    return switch (route) {
      AppNav.homeRoute => tr('home'),
      AppNav.teamRoute => tr('team'),
      AppNav.trainingRoute => tr('training'),
      AppNav.galleryRoute => tr('gallery'),
      AppNav.resultsRoute => tr('results'),
      AppNav.eventsRoute => tr('events'),
      AppNav.clubChatRoute => tr('clubChat'),
      AppNav.sponsorsRoute => tr('sponsors'),
      AppNav.liveRoute => tr('live'),
      AppNav.aboutRoute => tr('aboutClub'),
      _ => route,
    };
  }
}
