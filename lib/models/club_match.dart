import '../utils/firestore_utils.dart';

class ClubMatch {
  const ClubMatch({
    required this.id,
    required this.opponent,
    required this.competition,
    required this.isHome,
    required this.homeScore,
    required this.awayScore,
    required this.matchAt,
    required this.highlightsUrl,
    required this.createdAt,
  });

  final String id;
  final String opponent;
  final String competition;
  final bool isHome;
  final int? homeScore;
  final int? awayScore;
  final DateTime? matchAt;
  final String highlightsUrl;
  final DateTime? createdAt;

  ClubMatch copyWith({
    String? id,
    String? opponent,
    String? competition,
    bool? isHome,
    int? homeScore,
    int? awayScore,
    DateTime? matchAt,
    String? highlightsUrl,
    DateTime? createdAt,
  }) {
    return ClubMatch(
      id: id ?? this.id,
      opponent: opponent ?? this.opponent,
      competition: competition ?? this.competition,
      isHome: isHome ?? this.isHome,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      matchAt: matchAt ?? this.matchAt,
      highlightsUrl: highlightsUrl ?? this.highlightsUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ClubMatch.fromFirestore(String id, Map<String, Object?> data) {
    return ClubMatch(
      id: id,
      opponent: (data['opponent'] as String?) ?? '',
      competition: (data['competition'] as String?) ?? '',
      isHome: (data['isHome'] as bool?) ?? true,
      homeScore: (data['homeScore'] as int?),
      awayScore: (data['awayScore'] as int?),
      matchAt: readFirestoreDateTime(data['matchAt']),
      highlightsUrl: (data['highlightsUrl'] as String?) ?? '',
      createdAt: readFirestoreDateTime(data['createdAt']),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'opponent': opponent,
      'competition': competition,
      'isHome': isHome,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'matchAt': writeFirestoreDateTime(matchAt),
      'highlightsUrl': highlightsUrl,
      'createdAt': writeFirestoreDateTime(createdAt),
    };
  }
}
