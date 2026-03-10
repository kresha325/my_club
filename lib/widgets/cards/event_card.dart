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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageHeight = (constraints.maxHeight * 0.55)
              .clamp(90, 130)
              .toDouble();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: imageHeight,
                child: event.bannerUrl.trim().isEmpty
                    ? const PlaceholderImage(
                        height: double.infinity,
                        icon: Icons.event_outlined,
                      )
                    : Image.network(
                        event.bannerUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const PlaceholderImage(
                              height: double.infinity,
                              icon: Icons.event_outlined,
                            ),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title.isEmpty
                            ? '(Empty event title)'
                            : event.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(date, maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (event.location.trim().isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          event.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
