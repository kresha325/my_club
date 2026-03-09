import '../utils/firestore_utils.dart';

enum GalleryMediaType { image, video }

class GalleryItem {
  const GalleryItem({
    required this.id,
    required this.caption,
    required this.mediaUrl,
    required this.thumbnailUrl,
    required this.mediaType,
    required this.autopostEnabled,
    required this.autopostPlatforms,
    required this.createdAt,
  });

  final String id;
  final String caption;
  final String mediaUrl;
  final String thumbnailUrl;
  final GalleryMediaType mediaType;
  final bool autopostEnabled;
  final List<String> autopostPlatforms;
  final DateTime? createdAt;

  GalleryItem copyWith({
    String? id,
    String? caption,
    String? mediaUrl,
    String? thumbnailUrl,
    GalleryMediaType? mediaType,
    bool? autopostEnabled,
    List<String>? autopostPlatforms,
    DateTime? createdAt,
  }) {
    return GalleryItem(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      mediaType: mediaType ?? this.mediaType,
      autopostEnabled: autopostEnabled ?? this.autopostEnabled,
      autopostPlatforms: autopostPlatforms ?? this.autopostPlatforms,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory GalleryItem.fromFirestore(String id, Map<String, Object?> data) {
    final type = (data['mediaType'] as String?) ?? 'image';
    return GalleryItem(
      id: id,
      caption: (data['caption'] as String?) ?? '',
      mediaUrl: (data['mediaUrl'] as String?) ?? '',
      thumbnailUrl: (data['thumbnailUrl'] as String?) ?? '',
      mediaType: type == 'video'
          ? GalleryMediaType.video
          : GalleryMediaType.image,
      autopostEnabled: (data['autopostEnabled'] as bool?) ?? false,
      autopostPlatforms:
          (data['autopostPlatforms'] as List?)?.whereType<String>().toList() ??
          const [],
      createdAt: readFirestoreDateTime(data['createdAt']),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'caption': caption,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'mediaType': mediaType == GalleryMediaType.video ? 'video' : 'image',
      'autopostEnabled': autopostEnabled,
      'autopostPlatforms': autopostPlatforms,
      'createdAt': writeFirestoreDateTime(createdAt),
    };
  }
}
