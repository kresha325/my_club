import 'package:flutter/material.dart';

import '../app/dependencies.dart';
import '../models/club_event.dart';
import '../utils/app_localizations.dart';
import '../widgets/cards/event_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    String tr(String key) => AppLocalizations.t(context, key);

    return Column(
      children: [
        SectionHeader(title: tr('events')),
        Expanded(
          child: StreamBuilder<List<ClubEvent>>(
            stream: deps.eventsRepository.streamUpcoming(),
            builder: (context, snapshot) {
              final events = snapshot.data ?? const <ClubEvent>[];
              if (events.isEmpty) {
                return EmptyState(
                  title: tr('noEventsYet'),
                  subtitle: tr('eventsEmptySubtitle'),
                  icon: Icons.event_outlined,
                );
              }
              final crossAxisCount = MediaQuery.of(context).size.width >= 900
                  ? 2
                  : 1;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: GridView.builder(
                  itemCount: events.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: 240,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) =>
                      EventCard(event: events[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
