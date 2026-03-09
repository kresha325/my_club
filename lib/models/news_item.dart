import '../utils/firestore_utils.dart';

class NewsItem {
  const NewsItem({
    required this.id,
    required this.title,
    required this.body,
    required this.coverUrl,
    required this.publishedAt,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final String coverUrl;
  final DateTime? publishedAt;
  final DateTime? createdAt;

  NewsItem copyWith({
    String? id,
    String? title,
    String? body,
    String? coverUrl,
    DateTime? publishedAt,
    DateTime? createdAt,
  }) {
    return NewsItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      coverUrl: coverUrl ?? this.coverUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory NewsItem.fromFirestore(String id, Map<String, Object?> data) {
    return NewsItem(
      id: id,
      title: (data['title'] as String?) ?? '',
      body: (data['body'] as String?) ?? '',
      coverUrl: (data['coverUrl'] as String?) ?? '',
      publishedAt: readFirestoreDateTime(data['publishedAt']),
      createdAt: readFirestoreDateTime(data['createdAt']),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'title': title,
      'body': body,
      'coverUrl': coverUrl,
      'publishedAt': writeFirestoreDateTime(publishedAt),
      'createdAt': writeFirestoreDateTime(createdAt),
    };
  }
}
