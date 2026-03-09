import 'package:flutter/material.dart';

import '../app/dependencies.dart';
import '../models/ad.dart';
import '../models/sponsor.dart';
import '../widgets/cards/ad_banner.dart';
import '../widgets/cards/sponsor_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class SponsorsPage extends StatelessWidget {
  const SponsorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);

    return ListView(
      children: [
        const SectionHeader(title: 'Sponsors'),
        StreamBuilder<List<Sponsor>>(
          stream: deps.sponsorsRepository.streamAll(),
          builder: (context, snapshot) {
            final sponsors = snapshot.data ?? const <Sponsor>[];
            if (sponsors.isEmpty) {
              return const EmptyState(
                title: 'No sponsors yet',
                subtitle: 'Sponsor banners will appear here.',
                icon: Icons.handshake_outlined,
              );
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                children: [
                  for (final s in sponsors) ...[
                    SponsorCard(sponsor: s),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            );
          },
        ),
        const SectionHeader(title: 'Ads'),
        StreamBuilder<List<Ad>>(
          stream: deps.adsRepository.streamAll(limit: 50),
          builder: (context, snapshot) {
            final ads = snapshot.data ?? const <Ad>[];
            if (ads.isEmpty) {
              return const EmptyState(
                title: 'No ads yet',
                subtitle: 'Ads placeholders can be configured by admin.',
                icon: Icons.campaign_outlined,
              );
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                children: [
                  for (final ad in ads) ...[
                    AdBanner(ad: ad),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
