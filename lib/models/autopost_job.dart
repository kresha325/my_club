import '../utils/firestore_utils.dart';

class AutopostJob {
  const AutopostJob({
    required this.id,
    required this.contentType,
    required this.contentId,
    required this.platforms,
    required this.scheduledAt,
    required this.status,
    required this.lastError,
    required this.createdAt,
  });

  final String id;
  final String contentType;
  final String contentId;
  final List<String> platforms;
  final DateTime? scheduledAt;
  final String status;
  final String lastError;
  final DateTime? createdAt;

  AutopostJob copyWith({
    String? id,
    String? contentType,
    String? contentId,
    List<String>? platforms,
    DateTime? scheduledAt,
    String? status,
    String? lastError,
    DateTime? createdAt,
  }) {
    return AutopostJob(
      id: id ?? this.id,
      contentType: contentType ?? this.contentType,
      contentId: contentId ?? this.contentId,
      platforms: platforms ?? this.platforms,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory AutopostJob.fromFirestore(String id, Map<String, Object?> data) {
    return AutopostJob(
      id: id,
      contentType: (data['contentType'] as String?) ?? '',
      contentId: (data['contentId'] as String?) ?? '',
      platforms:
          (data['platforms'] as List?)?.whereType<String>().toList() ??
          const [],
      scheduledAt: readFirestoreDateTime(data['scheduledAt']),
      status: (data['status'] as String?) ?? 'queued',
      lastError: (data['lastError'] as String?) ?? '',
      createdAt: readFirestoreDateTime(data['createdAt']),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'contentType': contentType,
      'contentId': contentId,
      'platforms': platforms,
      'scheduledAt': writeFirestoreDateTime(scheduledAt),
      'status': status,
      'lastError': lastError,
      'createdAt': writeFirestoreDateTime(createdAt),
    };
  }
}
