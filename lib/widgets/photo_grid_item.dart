import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_media_viewer/models/photo_model.dart';
import 'package:flutter/material.dart';

class PhotoGridItem extends StatelessWidget {
  const PhotoGridItem({
    super.key,
    required this.photo,
    required this.onTap,
    required this.index,
  });

  final PhotoModel photo;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 250 + (index * 30).clamp(0, 320)),
      curve: Curves.easeOut,
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.scale(scale: 0.96 + (0.04 * value), child: child),
      ),
      child: Hero(
        tag: 'photo-${photo.id}',
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: photo.thumbUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                  placeholder: (_, __) => Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.08),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.10),
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                    child: Text(
                      photo.photographer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
