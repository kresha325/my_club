import '../utils/firestore_utils.dart';

class ClubEvent {
  const ClubEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startAt,
    required this.endAt,
    required this.bannerUrl,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime? startAt;
  final DateTime? endAt;
  final String bannerUrl;
  final DateTime? createdAt;

  ClubEvent copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    DateTime? startAt,
    DateTime? endAt,
    String? bannerUrl,
    DateTime? createdAt,
  }) {
    return ClubEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ClubEvent.fromFirestore(String id, Map<String, Object?> data) {
    return ClubEvent(
      id: id,
      title: (data['title'] as String?) ?? '',
      description: (data['description'] as String?) ?? '',
      location: (data['location'] as String?) ?? '',
      startAt: readFirestoreDateTime(data['startAt']),
      endAt: readFirestoreDateTime(data['endAt']),
      bannerUrl: (data['bannerUrl'] as String?) ?? '',
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
      'bannerUrl': bannerUrl,
      'createdAt': writeFirestoreDateTime(createdAt),
    };
  }
}
