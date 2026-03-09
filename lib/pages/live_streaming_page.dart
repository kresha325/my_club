import 'package:flutter/material.dart';

import '../utils/app_localizations.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class LiveStreamingPage extends StatelessWidget {
  const LiveStreamingPage({super.key});

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.t(context, key);

    return Column(
      children: [
        SectionHeader(title: tr('liveStreaming')),
        Expanded(
          child: EmptyState(
            title: tr('liveNotConfigured'),
            subtitle: tr('livePlaceholderSubtitle'),
            icon: Icons.live_tv_outlined,
          ),
        ),
      ],
    );
  }
}
