import 'package:flutter/material.dart';

import '../app/dependencies.dart';
import '../models/ad.dart';
import '../models/sponsor.dart';
import '../utils/app_localizations.dart';
import '../widgets/cards/ad_banner.dart';
import '../widgets/cards/sponsor_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class SponsorsPage extends StatelessWidget {
  const SponsorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    String tr(String key) => AppLocalizations.t(context, key);

    return ListView(
      children: [
        SectionHeader(title: tr('sponsors')),
        StreamBuilder<List<Sponsor>>(
          stream: deps.sponsorsRepository.streamAll(),
          builder: (context, snapshot) {
            final sponsors = snapshot.data ?? const <Sponsor>[];
            if (sponsors.isEmpty) {
              return EmptyState(
                title: tr('noSponsorsYet'),
                subtitle: tr('sponsorsEmptySubtitle'),
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
        SectionHeader(title: tr('ads')),
        StreamBuilder<List<Ad>>(
          stream: deps.adsRepository.streamAll(limit: 50),
          builder: (context, snapshot) {
            final ads = snapshot.data ?? const <Ad>[];
            if (ads.isEmpty) {
              return EmptyState(
                title: tr('noAdsYet'),
                subtitle: tr('adsEmptySubtitle'),
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
