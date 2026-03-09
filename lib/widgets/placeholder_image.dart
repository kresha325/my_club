import 'package:flutter/material.dart';

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({
    this.height = 160,
    this.width,
    this.icon = Icons.image_outlined,
    super.key,
  });

  final double height;
  final double? width;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 42,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}
