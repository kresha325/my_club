import 'package:flutter/material.dart';

import '../app/dependencies.dart';
import '../models/club_match.dart';
import '../utils/app_localizations.dart';
import '../widgets/cards/match_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    String tr(String key) => AppLocalizations.t(context, key);

    return Column(
      children: [
        SectionHeader(title: tr('results')),
        Expanded(
          child: StreamBuilder<List<ClubMatch>>(
            stream: deps.matchesRepository.streamLatest(),
            builder: (context, snapshot) {
              final matches = snapshot.data ?? const <ClubMatch>[];
              if (matches.isEmpty) {
                return EmptyState(
                  title: tr('noResultsYet'),
                  subtitle: tr('resultsEmptySubtitle'),
                  icon: Icons.sports_soccer_outlined,
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: matches.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
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
