import '../utils/firestore_utils.dart';

class StaffMember {
  const StaffMember({
    required this.id,
    required this.fullName,
    required this.position,
    required this.photoUrl,
    required this.createdAt,
  });

  final String id;
  final String fullName;
  final String position;
  final String photoUrl;
  final DateTime? createdAt;

  StaffMember copyWith({
    String? id,
    String? fullName,
    String? position,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return StaffMember(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      position: position ?? this.position,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory StaffMember.fromFirestore(String id, Map<String, Object?> data) {
    return StaffMember(
      id: id,
      fullName: (data['fullName'] as String?) ?? '',
      position: (data['position'] as String?) ?? '',
      photoUrl: (data['photoUrl'] as String?) ?? '',
      createdAt: readFirestoreDateTime(data['createdAt']),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'fullName': fullName,
      'position': position,
      'photoUrl': photoUrl,
      'createdAt': writeFirestoreDateTime(createdAt),
    };
  }
}
