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
        return LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth < 700
                ? constraints.maxWidth - 32
                : 360.0;
            return SizedBox(
              height: 250,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) => SizedBox(
                  width: cardWidth,
                  child: EventCard(event: items[index]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
