import '../utils/firestore_utils.dart';

class Ad {
  const Ad({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.clickUrl,
    required this.placement,
    required this.isActive,
    required this.startsAt,
    required this.endsAt,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String imageUrl;
  final String clickUrl;
  final String placement;
  final bool isActive;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final DateTime? createdAt;

  Ad copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? clickUrl,
    String? placement,
    bool? isActive,
    DateTime? startsAt,
    DateTime? endsAt,
    DateTime? createdAt,
  }) {
    return Ad(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      clickUrl: clickUrl ?? this.clickUrl,
      placement: placement ?? this.placement,
      isActive: isActive ?? this.isActive,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Ad.fromFirestore(String id, Map<String, Object?> data) {
    return Ad(
      id: id,
      title: (data['title'] as String?) ?? '',
      imageUrl: (data['imageUrl'] as String?) ?? '',
      clickUrl: (data['clickUrl'] as String?) ?? '',
      placement: (data['placement'] as String?) ?? '',
      isActive: (data['isActive'] as bool?) ?? false,
      startsAt: readFirestoreDateTime(data['startsAt']),
      endsAt: readFirestoreDateTime(data['endsAt']),
      createdAt: readFirestoreDateTime(data['createdAt']),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'clickUrl': clickUrl,
      'placement': placement,
      'isActive': isActive,
      'startsAt': writeFirestoreDateTime(startsAt),
      'endsAt': writeFirestoreDateTime(endsAt),
      'createdAt': writeFirestoreDateTime(createdAt),
    };
  }
}
