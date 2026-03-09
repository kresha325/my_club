import 'package:flutter/material.dart';

import '../../models/sponsor.dart';
import '../placeholder_image.dart';

class SponsorCard extends StatelessWidget {
  const SponsorCard({required this.sponsor, super.key});

  final Sponsor sponsor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: sponsor.logoUrl.trim().isEmpty
            ? const PlaceholderImage(height: 40, width: 40, icon: Icons.store)
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  sponsor.logoUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const PlaceholderImage(
                    height: 40,
                    width: 40,
                    icon: Icons.store,
                  ),
                ),
              ),
        title: Text(
          sponsor.name.isEmpty ? '(Empty sponsor name)' : sponsor.name,
        ),
        subtitle: Text(
          sponsor.tier.trim().isEmpty
              ? 'Tier: (not set)'
              : 'Tier: ${sponsor.tier}',
        ),
      ),
    );
  }
}
