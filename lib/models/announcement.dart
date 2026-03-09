import '../utils/firestore_utils.dart';

enum ParticipationChoice { yes, no }

ParticipationChoice? participationChoiceFromFirestore(Object? value) {
  return switch (value) {
    'yes' => ParticipationChoice.yes,
    'no' => ParticipationChoice.no,
    _ => null,
  };
}

String participationChoiceToFirestore(ParticipationChoice value) {
  return value == ParticipationChoice.yes ? 'yes' : 'no';
}

class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.startsAt,
    required this.requiresParticipation,
  });

  final String id;
  final String title;
  final String message;
  final DateTime? createdAt;
  final DateTime? startsAt;
  final bool requiresParticipation;

  Announcement copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? createdAt,
    DateTime? startsAt,
    bool? requiresParticipation,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      startsAt: startsAt ?? this.startsAt,
      requiresParticipation:
          requiresParticipation ?? this.requiresParticipation,
    );
  }

  factory Announcement.fromFirestore(String id, Map<String, Object?> data) {
    return Announcement(
      id: id,
      title: (data['title'] as String?) ?? '',
      message: (data['message'] as String?) ?? '',
      createdAt: readFirestoreDateTime(data['createdAt']),
      startsAt: readFirestoreDateTime(data['startsAt']),
      requiresParticipation: (data['requiresParticipation'] as bool?) ?? false,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'title': title,
      'message': message,
      'createdAt': writeFirestoreDateTime(createdAt),
      'startsAt': writeFirestoreDateTime(startsAt),
      'requiresParticipation': requiresParticipation,
    };
  }
}

class AnnouncementResponse {
  const AnnouncementResponse({
    required this.uid,
    required this.displayName,
    required this.choice,
    required this.respondedAt,
  });

  final String uid;
  final String displayName;
  final ParticipationChoice? choice;
  final DateTime? respondedAt;

  AnnouncementResponse copyWith({
    String? uid,
    String? displayName,
    ParticipationChoice? choice,
    DateTime? respondedAt,
  }) {
    return AnnouncementResponse(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      choice: choice ?? this.choice,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }

  factory AnnouncementResponse.fromFirestore(
    String uid,
    Map<String, Object?> data,
  ) {
    return AnnouncementResponse(
      uid: uid,
      displayName: (data['displayName'] as String?) ?? '',
      choice: participationChoiceFromFirestore(data['choice']),
      respondedAt: readFirestoreDateTime(data['respondedAt']),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'uid': uid,
      'displayName': displayName,
      'choice': choice == null ? null : participationChoiceToFirestore(choice!),
      'respondedAt': writeFirestoreDateTime(respondedAt),
    };
  }
}
