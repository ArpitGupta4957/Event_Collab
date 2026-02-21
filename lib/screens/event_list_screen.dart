import 'package:event_media_viewer/core/utils.dart';
import 'package:event_media_viewer/providers/event_provider.dart';
import 'package:event_media_viewer/providers/theme_provider.dart';
import 'package:event_media_viewer/screens/event_detail_screen.dart';
import 'package:event_media_viewer/widgets/empty_state_widget.dart';
import 'package:event_media_viewer/widgets/error_widget.dart';
import 'package:event_media_viewer/widgets/event_card.dart';
import 'package:event_media_viewer/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  Future<void> _openAddEventSheet() async {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Event',
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                    prefixIcon: Icon(Icons.event_note_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter event name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: codeController,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Event Code',
                    prefixIcon: Icon(Icons.qr_code_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter event code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                Consumer<EventProvider>(
                  builder: (context, provider, _) {
                    return ElevatedButton.icon(
                      onPressed: provider.isSubmitting
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) return;
                              final success = await provider.addEvent(
                                name: nameController.text,
                                code: codeController.text,
                              );
                              if (!context.mounted || !sheetContext.mounted) {
                                return;
                              }
                              final messenger = ScaffoldMessenger.of(context);
                              if (success) {
                                Navigator.of(sheetContext).pop();
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Event added successfully.'),
                                  ),
                                );
                              } else {
                                final message =
                                    provider.errorMessage ??
                                    'Could not add event. Please try again.';
                                messenger.showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                              }
                            },
                      icon: provider.isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add_circle_outline_rounded),
                      label: Text(
                        provider.isSubmitting ? 'Adding...' : 'Add Event',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    nameController.dispose();
    codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Media Viewer'),
        actions: [
          PopupMenuButton<ThemePreference>(
            tooltip: 'Theme mode',
            icon: const Icon(Icons.brightness_6_rounded),
            onSelected: (value) {
              context.read<ThemeProvider>().setPreference(value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: ThemePreference.system,
                child: Text('System Mode'),
              ),
              PopupMenuItem(
                value: ThemePreference.light,
                child: Text('Light Mode'),
              ),
              PopupMenuItem(
                value: ThemePreference.dark,
                child: Text('Dark Mode'),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddEventSheet,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Event'),
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.events.isEmpty) {
            return const LoadingWidget.list();
          }

          if (provider.errorMessage != null && provider.events.isEmpty) {
            return AppErrorWidget(
              message: provider.errorMessage!,
              onRetry: provider.fetchEvents,
            );
          }

          if (provider.events.isEmpty) {
            return EmptyStateWidget(
              title: 'No events available',
              subtitle: 'Add event rows in Supabase and pull to refresh.',
              icon: Icons.celebration_outlined,
              onAction: provider.fetchEvents,
              actionLabel: 'Reload',
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refreshEvents,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.9),
                            Theme.of(context).colorScheme.primaryContainer
                                .withValues(alpha: 0.95),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.22),
                            blurRadius: 22,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Events',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${provider.events.length} events available',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.92),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index.isOdd) {
                        return const SizedBox(height: 12);
                      }
                      final eventIndex = index ~/ 2;
                      final event = provider.events[eventIndex];
                      return EventCard(
                        event: event,
                        index: eventIndex,
                        onTap: () {
                          Navigator.of(context).push(
                            AppTransitions.fadeSlide(
                              EventDetailScreen(event: event),
                            ),
                          );
                        },
                      );
                    }, childCount: provider.events.length * 2 - 1),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
