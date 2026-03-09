import 'package:flutter/material.dart';

import '../app/dependencies.dart';
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

    return ListView(
      children: [
        const SectionHeader(title: 'Latest News'),
        HomeNewsSection(stream: deps.newsRepository.streamLatest()),
        const SectionHeader(title: 'Upcoming Events'),
        HomeEventsSection(stream: deps.eventsRepository.streamUpcoming()),
        const SectionHeader(title: 'Gallery'),
        HomeGallerySection(stream: deps.galleryRepository.streamLatest()),
        const SectionHeader(title: 'Ads (placeholder)'),
        HomeAdsSection(stream: deps.adsRepository.streamAll(limit: 5)),
        const SizedBox(height: 24),
      ],
    );
  }
}
