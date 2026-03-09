import 'package:flutter/material.dart';

import '../../models/ad.dart';
import '../cards/ad_banner.dart';
import '../empty_state.dart';

class HomeAdsSection extends StatelessWidget {
  const HomeAdsSection({required this.stream, super.key});

  final Stream<List<Ad>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Ad>>(
      stream: stream,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <Ad>[];
        if (items.isEmpty) {
          return const EmptyState(
            title: 'No ads configured',
            subtitle:
                'Use Admin → Ads to add sponsor banners / ads placeholders.',
            icon: Icons.campaign_outlined,
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (final ad in items) ...[
                AdBanner(ad: ad),
                const SizedBox(height: 12),
              ],
            ],
          ),
        );
      },
    );
  }
}
