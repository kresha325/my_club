import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../utils/app_constants.dart';
import '../utils/app_localizations.dart';
import '../utils/app_theme.dart';
import 'app_router.dart';
import 'dependencies.dart';
import 'locale_scope.dart';
import 'theme_scope.dart';

class ClubApp extends StatefulWidget {
  const ClubApp({super.key});

  @override
  State<ClubApp> createState() => _ClubAppState();
}

class _ClubAppState extends State<ClubApp> {
  final ThemeController _themeController = ThemeController();
  final LocaleController _localeController = LocaleController();

  @override
  void dispose() {
    _themeController.dispose();
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    final router = createAppRouter(deps);

    return LocaleScope(
      controller: _localeController,
      child: ThemeScope(
        controller: _themeController,
        child: ValueListenableBuilder<Locale>(
          valueListenable: _localeController,
          builder: (context, locale, child) {
            return ValueListenableBuilder<ThemeMode>(
              valueListenable: _themeController,
              builder: (context, mode, child) {
                return MaterialApp.router(
                  title: AppConstants.appName,
                  theme: AppTheme.light(),
                  darkTheme: AppTheme.dark(),
                  themeMode: mode,
                  locale: locale,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  routerConfig: router,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
