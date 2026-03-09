import 'package:flutter/material.dart';

import '../app/dependencies.dart';
import '../models/club_match.dart';
import '../widgets/cards/match_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);

    return Column(
      children: [
        const SectionHeader(title: 'Results'),
        Expanded(
          child: StreamBuilder<List<ClubMatch>>(
            stream: deps.matchesRepository.streamLatest(),
            builder: (context, snapshot) {
              final matches = snapshot.data ?? const <ClubMatch>[];
              if (matches.isEmpty) {
                return const EmptyState(
                  title: 'No matches yet',
                  subtitle: 'Results will appear here once added by admin.',
                  icon: Icons.sports_soccer_outlined,
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: matches.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) =>
                    MatchCard(match: matches[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
