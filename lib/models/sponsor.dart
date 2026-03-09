import '../utils/firestore_utils.dart';

class Sponsor {
  const Sponsor({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.websiteUrl,
    required this.tier,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String logoUrl;
  final String websiteUrl;
  final String tier;
  final DateTime? createdAt;

  Sponsor copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? websiteUrl,
    String? tier,
    DateTime? createdAt,
  }) {
    return Sponsor(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      tier: tier ?? this.tier,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Sponsor.fromFirestore(String id, Map<String, Object?> data) {
    return Sponsor(
      id: id,
      name: (data['name'] as String?) ?? '',
      logoUrl: (data['logoUrl'] as String?) ?? '',
      websiteUrl: (data['websiteUrl'] as String?) ?? '',
      tier: (data['tier'] as String?) ?? '',
      createdAt: readFirestoreDateTime(data['createdAt']),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'name': name,
      'logoUrl': logoUrl,
      'websiteUrl': websiteUrl,
      'tier': tier,
      'createdAt': writeFirestoreDateTime(createdAt),
    };
  }
}
