import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/club_match.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({required this.match, super.key});

  final ClubMatch match;

  @override
  Widget build(BuildContext context) {
    final date = match.matchAt == null
        ? 'TBD'
        : DateFormat.yMMMd().format(match.matchAt!.toLocal());
    final score = (match.homeScore == null || match.awayScore == null)
        ? '—'
        : '${match.homeScore}-${match.awayScore}';

    return Card(
      child: ListTile(
        leading: const Icon(Icons.sports_soccer_outlined),
        title: Text(match.opponent.isEmpty ? '(Opponent TBD)' : match.opponent),
        subtitle: Text(
          [
            if (match.competition.trim().isNotEmpty) match.competition.trim(),
            date,
          ].join(' • '),
        ),
        trailing: Text(score, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
