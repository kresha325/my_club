import 'package:flutter/material.dart';

import '../../models/athlete.dart';
import '../placeholder_image.dart';

class AthleteCard extends StatelessWidget {
  const AthleteCard({required this.athlete, super.key});

  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: athlete.photoUrl.trim().isEmpty
            ? const SizedBox.square(
                dimension: 48,
                child: PlaceholderImage(height: 48, width: 48),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  athlete.photoUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const PlaceholderImage(height: 48, width: 48),
                ),
              ),
        title: Text(
          athlete.fullName.isEmpty ? '(Empty name)' : athlete.fullName,
        ),
        subtitle: Text(
          [
                if (athlete.number.trim().isNotEmpty)
                  '#${athlete.number.trim()}',
                if (athlete.position.trim().isNotEmpty) athlete.position.trim(),
              ].join(' • ').isEmpty
              ? 'No details yet.'
              : [
                  if (athlete.number.trim().isNotEmpty)
                    '#${athlete.number.trim()}',
                  if (athlete.position.trim().isNotEmpty)
                    athlete.position.trim(),
                ].join(' • '),
        ),
      ),
    );
  }
}
