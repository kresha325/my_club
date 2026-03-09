import 'package:flutter/material.dart';

import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class LiveStreamingPage extends StatelessWidget {
  const LiveStreamingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SectionHeader(title: 'Live Streaming'),
        Expanded(
          child: EmptyState(
            title: 'Live streaming not configured',
            subtitle:
                'Placeholder for YouTube Live / Facebook Live embeds.\n\n'
                'Admin/developer: store stream URLs in Firestore and build an embed player here.',
            icon: Icons.live_tv_outlined,
          ),
        ),
      ],
    );
  }
}
