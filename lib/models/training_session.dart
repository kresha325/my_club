import '../utils/firestore_utils.dart';

class TrainingSession {
  const TrainingSession({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startAt,
    required this.endAt,
    required this.coach,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime? startAt;
  final DateTime? endAt;
  final String coach;
  final DateTime? createdAt;

  TrainingSession copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    DateTime? startAt,
    DateTime? endAt,
    String? coach,
    DateTime? createdAt,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      coach: coach ?? this.coach,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TrainingSession.fromFirestore(String id, Map<String, Object?> data) {
    return TrainingSession(
      id: id,
      title: (data['title'] as String?) ?? '',
      description: (data['description'] as String?) ?? '',
      location: (data['location'] as String?) ?? '',
      startAt: readFirestoreDateTime(data['startAt']),
      endAt: readFirestoreDateTime(data['endAt']),
      coach: (data['coach'] as String?) ?? '',
      createdAt: readFirestoreDateTime(data['createdAt']),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'startAt': writeFirestoreDateTime(startAt),
      'endAt': writeFirestoreDateTime(endAt),
      'coach': coach,
      'createdAt': writeFirestoreDateTime(createdAt),
    };
  }
}
