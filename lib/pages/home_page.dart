import 'package:flutter/material.dart';

import '../app/dependencies.dart';
import '../utils/app_localizations.dart';
import '../widgets/section_header.dart';
import '../widgets/home/home_ads_section.dart';
import '../widgets/home/home_events_section.dart';
import '../widgets/home/home_gallery_section.dart';
import '../widgets/home/home_news_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    String tr(String key) => AppLocalizations.t(context, key);

    return ListView(
      children: [
        SectionHeader(title: tr('latestNews')),
        HomeNewsSection(stream: deps.newsRepository.streamLatest()),
        SectionHeader(title: tr('upcomingEvents')),
        HomeEventsSection(stream: deps.eventsRepository.streamUpcoming()),
        SectionHeader(title: tr('gallery')),
        HomeGallerySection(stream: deps.galleryRepository.streamLatest()),
        SectionHeader(title: tr('adsPlaceholder')),
        HomeAdsSection(stream: deps.adsRepository.streamAll(limit: 5)),
        const SizedBox(height: 24),
      ],
    );
  }
}
