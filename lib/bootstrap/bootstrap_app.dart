import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../app/club_app.dart';
import '../app/dependencies.dart';
import '../firebase_options.dart';
import '../pages/system/firebase_setup_page.dart';
import '../pages/system/loading_page.dart';

class BootstrapApp extends StatelessWidget {
  const BootstrapApp({super.key});

  Route<dynamic> _bootstrapRoute(Widget child) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/'),
      builder: (_) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (_) => _bootstrapRoute(const LoadingPage()),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (_) =>
                _bootstrapRoute(FirebaseSetupPage(error: snapshot.error)),
          );
        }

        final deps = AppDependencies.create();
        return DependenciesScope(deps: deps, child: const ClubApp());
      },
    );
  }
}
