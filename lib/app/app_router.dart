import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/admin/admin_ads_page.dart';
import '../pages/admin/admin_athletes_page.dart';
import '../pages/admin/admin_autopost_page.dart';
import '../pages/admin/admin_events_page.dart';
import '../pages/admin/admin_gallery_page.dart';
import '../pages/admin/admin_home_page.dart';
import '../pages/admin/admin_login_page.dart';
import '../pages/admin/admin_matches_page.dart';
import '../pages/admin/admin_news_page.dart';
import '../pages/admin/admin_sponsors_page.dart';
import '../pages/events_page.dart';
import '../pages/gallery_page.dart';
import '../pages/home_page.dart';
import '../pages/live_streaming_page.dart';
import '../pages/membership_page.dart';
import '../pages/results_page.dart';
import '../pages/sponsors_page.dart';
import '../pages/team_page.dart';
import '../utils/app_nav.dart';
import '../utils/go_router_refresh_stream.dart';
import '../widgets/admin/admin_scaffold.dart';
import '../widgets/app_scaffold.dart';
import 'dependencies.dart';

GoRouter createAppRouter(AppDependencies deps) {
  return GoRouter(
    initialLocation: AppNav.homeRoute,
    refreshListenable: GoRouterRefreshStream(
      deps.authService.authStateChanges(),
    ),
    redirect: (context, state) {
      final isAdminRoute = state.matchedLocation.startsWith(AppNav.adminRoot);
      final isAdminLogin = state.matchedLocation == AppNav.adminLoginRoute;
      final signedIn = deps.authService.currentUser != null;

      if (isAdminRoute && !isAdminLogin && !signedIn) {
        return AppNav.adminLoginRoute;
      }
      if (isAdminLogin && signedIn) {
        return AppNav.adminHomeRoute;
      }
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppScaffold(location: state.matchedLocation, child: child);
        },
        routes: [
          GoRoute(
            path: AppNav.homeRoute,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppNav.teamRoute,
            builder: (context, state) => const TeamPage(),
          ),
          GoRoute(
            path: AppNav.galleryRoute,
            builder: (context, state) => const GalleryPage(),
          ),
          GoRoute(
            path: AppNav.resultsRoute,
            builder: (context, state) => const ResultsPage(),
          ),
          GoRoute(
            path: AppNav.eventsRoute,
            builder: (context, state) => const EventsPage(),
          ),
          GoRoute(
            path: AppNav.sponsorsRoute,
            builder: (context, state) => const SponsorsPage(),
          ),
          GoRoute(
            path: AppNav.liveRoute,
            builder: (context, state) => const LiveStreamingPage(),
          ),
          GoRoute(
            path: AppNav.membershipRoute,
            builder: (context, state) => const MembershipPage(),
          ),
        ],
      ),
      GoRoute(
        path: AppNav.adminLoginRoute,
        builder: (context, state) => const AdminLoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AdminScaffold(location: state.matchedLocation, child: child);
        },
        routes: [
          GoRoute(
            path: AppNav.adminHomeRoute,
            builder: (context, state) => const AdminHomePage(),
          ),
          GoRoute(
            path: AppNav.adminAthletesRoute,
            builder: (context, state) => const AdminAthletesPage(),
          ),
          GoRoute(
            path: AppNav.adminNewsRoute,
            builder: (context, state) => const AdminNewsPage(),
          ),
          GoRoute(
            path: AppNav.adminEventsRoute,
            builder: (context, state) => const AdminEventsPage(),
          ),
          GoRoute(
            path: AppNav.adminMatchesRoute,
            builder: (context, state) => const AdminMatchesPage(),
          ),
          GoRoute(
            path: AppNav.adminGalleryRoute,
            builder: (context, state) => const AdminGalleryPage(),
          ),
          GoRoute(
            path: AppNav.adminSponsorsRoute,
            builder: (context, state) => const AdminSponsorsPage(),
          ),
          GoRoute(
            path: AppNav.adminAdsRoute,
            builder: (context, state) => const AdminAdsPage(),
          ),
          GoRoute(
            path: AppNav.adminAutopostRoute,
            builder: (context, state) => const AdminAutopostPage(),
          ),
        ],
      ),
    ],
  );
}
