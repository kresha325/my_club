import 'package:flutter/material.dart';

import '../../models/ad.dart';
import '../placeholder_image.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({required this.ad, super.key});

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (ad.imageUrl.trim().isEmpty)
            const PlaceholderImage(height: 120, icon: Icons.campaign_outlined)
          else
            Image.network(
              ad.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const PlaceholderImage(
                height: 120,
                icon: Icons.campaign_outlined,
              ),
            ),
          Positioned(
            left: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                ad.title.isEmpty ? 'Ad placeholder' : ad.title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
