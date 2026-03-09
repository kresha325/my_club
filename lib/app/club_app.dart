import 'package:flutter/material.dart';

import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import 'app_router.dart';
import 'dependencies.dart';

class ClubApp extends StatelessWidget {
  const ClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    final router = createAppRouter(deps);

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
