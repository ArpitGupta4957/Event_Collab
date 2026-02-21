import 'package:event_media_viewer/core/utils.dart';
import 'package:event_media_viewer/providers/photo_provider.dart';
import 'package:event_media_viewer/screens/photo_viewer_screen.dart';
import 'package:event_media_viewer/widgets/empty_state_widget.dart';
import 'package:event_media_viewer/widgets/error_widget.dart';
import 'package:event_media_viewer/widgets/loading_widget.dart';
import 'package:event_media_viewer/widgets/photo_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotoGalleryScreen extends StatefulWidget {
  const PhotoGalleryScreen({super.key, required this.initialQuery});

  final String initialQuery;

  @override
  State<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  late final TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PhotoProvider>().fetchPhotos(widget.initialQuery);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<PhotoProvider>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 240) {
      provider.loadMore();
    }
  }

  Future<void> _onSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    await context.read<PhotoProvider>().fetchPhotos(query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Gallery')),
      body: Consumer<PhotoProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _onSearch(),
                        decoration: const InputDecoration(
                          hintText: 'Search photos by event',
                          prefixIcon: Icon(Icons.search_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: _onSearch,
                      icon: const Icon(Icons.arrow_forward_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildBody(provider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(PhotoProvider provider) {
    if (provider.isLoading && provider.photos.isEmpty) {
      return const LoadingWidget.grid();
    }

    if (provider.errorMessage != null && provider.photos.isEmpty) {
      return AppErrorWidget(
        message: provider.errorMessage!,
        onRetry: _onSearch,
      );
    }

    if (provider.photos.isEmpty) {
      return EmptyStateWidget(
        title: 'No photos found',
        subtitle: 'Try another event name to discover more images.',
        icon: Icons.photo_size_select_actual_outlined,
        onAction: _onSearch,
        actionLabel: 'Search Again',
      );
    }

    return RefreshIndicator(
      onRefresh: provider.refreshPhotos,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: provider.photos.length + (provider.isLoadingMore ? 2 : 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          if (index >= provider.photos.length) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(strokeWidth: 2),
            );
          }

          final photo = provider.photos[index];
          return PhotoGridItem(
            photo: photo,
            index: index,
            onTap: () {
              Navigator.of(context).push(
                AppTransitions.fadeSlide(
                  PhotoViewerScreen(
                    photos: provider.photos,
                    initialIndex: index,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
