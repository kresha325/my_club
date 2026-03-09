import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/club_event.dart';
import '../placeholder_image.dart';

class EventCard extends StatelessWidget {
  const EventCard({required this.event, super.key});

  final ClubEvent event;

  @override
  Widget build(BuildContext context) {
    final date = event.startAt == null
        ? 'TBD'
        : DateFormat.yMMMd().add_Hm().format(event.startAt!.toLocal());

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (event.bannerUrl.trim().isEmpty)
            const PlaceholderImage(height: 120, icon: Icons.event_outlined)
          else
            Image.network(
              event.bannerUrl,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const PlaceholderImage(
                    height: 120,
                    icon: Icons.event_outlined,
                  ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title.isEmpty ? '(Empty event title)' : event.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(date),
                if (event.location.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(event.location),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
