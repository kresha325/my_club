import 'package:flutter/material.dart';

import '../../models/club_event.dart';
import '../cards/event_card.dart';
import '../empty_state.dart';

class HomeEventsSection extends StatelessWidget {
  const HomeEventsSection({required this.stream, super.key});

  final Stream<List<ClubEvent>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ClubEvent>>(
      stream: stream,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <ClubEvent>[];
        if (items.isEmpty) {
          return const EmptyState(
            title: 'No events yet',
            subtitle: 'Admin will add tournaments and events here.',
            icon: Icons.event_outlined,
          );
        }
        final crossAxisCount = MediaQuery.of(context).size.width >= 900 ? 3 : 1;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: 210,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) => EventCard(event: items[index]),
          ),
        );
      },
    );
  }
}
