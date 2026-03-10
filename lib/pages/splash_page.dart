import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_nav.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const Duration _splashDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _goToHomeAfterDelay();
  }

  Future<void> _goToHomeAfterDelay() async {
    await Future<void>.delayed(_splashDuration);
    if (!mounted) return;
    context.go(AppNav.homeRoute);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1F44),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Miresevini ne Kolosi Infinit',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'wresling club',
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
