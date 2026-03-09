import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_constants.dart';
import '../utils/app_nav.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String _heroAsset = 'assets/images/kolosi_logo.jpg';
  static const String _sadikAsset = _heroAsset;
  static const String _trainerAsset = _heroAsset;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              children: [
                _AssetPhotoCard(
                  height: 190,
                  assetPath: _heroAsset,
                  fallbackText: 'Shto foton kryesore ne assets/images/',
                ),
                const SizedBox(height: 20),
                Text(
                  'Miresevini ne Kolosi Infinit wresling club',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Ketu ju mirepresin kampioni i botes Sadik Ferati dhe traineri yne.',
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AssetPhotoCard(
                          height: 180,
                          assetPath: _sadikAsset,
                          fallbackText:
                              'Vendos foton: assets/images/sadik_ferati.jpg',
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Sadik Ferati',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text('Kampion i botes'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _AssetPhotoCard(
                  height: 170,
                  assetPath: _trainerAsset,
                  fallbackText:
                      'Vendos foton e trainerit: assets/images/trainer.jpg',
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => context.go(AppNav.homeRoute),
                  icon: const Icon(Icons.arrow_forward),
                  label: Text('Vazhdo ne ${AppConstants.appName}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AssetPhotoCard extends StatelessWidget {
  const _AssetPhotoCard({
    required this.height,
    required this.assetPath,
    required this.fallbackText,
  });

  final double height;
  final String assetPath;
  final String fallbackText;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(fallbackText, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}
