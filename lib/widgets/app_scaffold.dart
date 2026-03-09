import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/locale_scope.dart';
import '../utils/app_constants.dart';
import '../utils/app_localizations.dart';
import '../utils/app_nav.dart';
import '../app/theme_scope.dart';
import 'app_drawer.dart';

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
    final destinations = AppNav.publicDestinations;
    final selectedIndex = AppNav.indexForLocation(
      location: location,
      destinations: destinations,
    );

    final isWide = MediaQuery.of(context).size.width >= 900;

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
          TextButton.icon(
            onPressed: () => context.go(AppNav.adminHomeRoute),
            icon: const Icon(Icons.admin_panel_settings_outlined),
            label: Text(tr('admin')),
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
