import 'package:event_media_viewer/core/utils.dart';
import 'package:event_media_viewer/models/event_model.dart';
import 'package:event_media_viewer/screens/photo_gallery_screen.dart';
import 'package:flutter/material.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.event});

  final EventModel event;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _expanded = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 120), () {
      if (mounted) {
        setState(() => _expanded = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'event-${widget.event.id}',
              child: Material(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).cardColor,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 380),
                  curve: Curves.easeOutCubic,
                  height: _expanded ? 180 : 130,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.08),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.event.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Code: ${widget.event.code}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapCancel: () => setState(() => _pressed = false),
              onTapUp: (_) => setState(() => _pressed = false),
              child: AnimatedScale(
                scale: _pressed ? 0.97 : 1,
                duration: const Duration(milliseconds: 140),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      AppTransitions.fadeSlide(
                        PhotoGalleryScreen(initialQuery: widget.event.name),
                      ),
                    );
                  },
                  icon: const Icon(Icons.photo_library_rounded),
                  label: const Text('View Photos'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
