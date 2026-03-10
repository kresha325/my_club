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
        return LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth < 700
                ? constraints.maxWidth - 32
                : 360.0;
            return SizedBox(
              height: 132,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) => SizedBox(
                  width: cardWidth,
                  child: AdBanner(ad: items[index]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
