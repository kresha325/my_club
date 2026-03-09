import '../utils/firestore_utils.dart';

class Athlete {
  const Athlete({
    required this.id,
    required this.fullName,
    required this.position,
    required this.number,
    required this.photoUrl,
    required this.bio,
    required this.createdAt,
  });

  final String id;
  final String fullName;
  final String position;
  final String number;
  final String photoUrl;
  final String bio;
  final DateTime? createdAt;

  Athlete copyWith({
    String? id,
    String? fullName,
    String? position,
    String? number,
    String? photoUrl,
    String? bio,
    DateTime? createdAt,
  }) {
    return Athlete(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      position: position ?? this.position,
      number: number ?? this.number,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Athlete.fromFirestore(String id, Map<String, Object?> data) {
    return Athlete(
      id: id,
      fullName: (data['fullName'] as String?) ?? '',
      position: (data['position'] as String?) ?? '',
      number: (data['number'] as String?) ?? '',
      photoUrl: (data['photoUrl'] as String?) ?? '',
      bio: (data['bio'] as String?) ?? '',
      createdAt: readFirestoreDateTime(data['createdAt']),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'fullName': fullName,
      'position': position,
      'number': number,
      'photoUrl': photoUrl,
      'bio': bio,
      'createdAt': writeFirestoreDateTime(createdAt),
    };
  }
}
