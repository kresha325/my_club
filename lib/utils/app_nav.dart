import 'package:flutter/material.dart';

class NavDestination {
  const NavDestination({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}

class AppNav {
  static const String homeRoute = '/';
  static const String teamRoute = '/team';
  static const String galleryRoute = '/gallery';
  static const String resultsRoute = '/results';
  static const String eventsRoute = '/events';
  static const String sponsorsRoute = '/sponsors';
  static const String liveRoute = '/live';
  static const String membershipRoute = '/membership';

  static const String adminRoot = '/admin';
  static const String adminLoginRoute = '/admin/login';
  static const String adminHomeRoute = '/admin';
  static const String adminAthletesRoute = '/admin/athletes';
  static const String adminNewsRoute = '/admin/news';
  static const String adminEventsRoute = '/admin/events';
  static const String adminMatchesRoute = '/admin/matches';
  static const String adminGalleryRoute = '/admin/gallery';
  static const String adminSponsorsRoute = '/admin/sponsors';
  static const String adminAdsRoute = '/admin/ads';
  static const String adminAutopostRoute = '/admin/autopost';

  static const List<NavDestination> publicDestinations = [
    NavDestination(label: 'Home', icon: Icons.home_outlined, route: homeRoute),
    NavDestination(
      label: 'Team',
      icon: Icons.groups_outlined,
      route: teamRoute,
    ),
    NavDestination(
      label: 'Gallery',
      icon: Icons.photo_library_outlined,
      route: galleryRoute,
    ),
    NavDestination(
      label: 'Results',
      icon: Icons.emoji_events_outlined,
      route: resultsRoute,
    ),
    NavDestination(
      label: 'Events',
      icon: Icons.event_outlined,
      route: eventsRoute,
    ),
    NavDestination(
      label: 'Sponsors',
      icon: Icons.handshake_outlined,
      route: sponsorsRoute,
    ),
    NavDestination(
      label: 'Live',
      icon: Icons.live_tv_outlined,
      route: liveRoute,
    ),
  ];

  static const List<NavDestination> adminDestinations = [
    NavDestination(
      label: 'Dashboard',
      icon: Icons.space_dashboard_outlined,
      route: adminHomeRoute,
    ),
    NavDestination(
      label: 'Athletes',
      icon: Icons.groups_outlined,
      route: adminAthletesRoute,
    ),
    NavDestination(
      label: 'News',
      icon: Icons.feed_outlined,
      route: adminNewsRoute,
    ),
    NavDestination(
      label: 'Events',
      icon: Icons.event_outlined,
      route: adminEventsRoute,
    ),
    NavDestination(
      label: 'Matches',
      icon: Icons.sports_soccer_outlined,
      route: adminMatchesRoute,
    ),
    NavDestination(
      label: 'Gallery',
      icon: Icons.photo_library_outlined,
      route: adminGalleryRoute,
    ),
    NavDestination(
      label: 'Sponsors',
      icon: Icons.handshake_outlined,
      route: adminSponsorsRoute,
    ),
    NavDestination(
      label: 'Ads',
      icon: Icons.campaign_outlined,
      route: adminAdsRoute,
    ),
    NavDestination(
      label: 'Autopost',
      icon: Icons.send_outlined,
      route: adminAutopostRoute,
    ),
  ];

  static int indexForLocation({
    required String location,
    required List<NavDestination> destinations,
  }) {
    final index = destinations.indexWhere((d) => location == d.route);
    return index >= 0 ? index : 0;
  }
}
