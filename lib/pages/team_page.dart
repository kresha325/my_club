import 'package:flutter/material.dart';

import '../app/dependencies.dart';
import '../models/athlete.dart';
import '../widgets/cards/athlete_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);

    return Column(
      children: [
        const SectionHeader(title: 'Team'),
        Expanded(
          child: StreamBuilder<List<Athlete>>(
            stream: deps.athletesRepository.streamAll(),
            builder: (context, snapshot) {
              final athletes = snapshot.data ?? const <Athlete>[];
              if (athletes.isEmpty) {
                return const EmptyState(
                  title: 'No athletes yet',
                  subtitle: 'Admin will add players to the roster.',
                  icon: Icons.groups_outlined,
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: athletes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) =>
                    AthleteCard(athlete: athletes[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
