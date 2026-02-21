import 'package:event_media_viewer/models/photo_model.dart';
import 'package:event_media_viewer/services/unsplash_service.dart';
import 'package:flutter/foundation.dart';

class PhotoProvider extends ChangeNotifier {
  PhotoProvider({required UnsplashService unsplashService})
    : _unsplashService = unsplashService;

  final UnsplashService _unsplashService;

  final List<PhotoModel> _photos = [];
  String _query = '';
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _totalPages = 1;
  String? _errorMessage;

  List<PhotoModel> get photos => List.unmodifiable(_photos);
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  int get currentPage => _currentPage;
  bool get hasMore => _currentPage < _totalPages;
  String get query => _query;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPhotos(String query) async {
    _query = query.trim();
    _isLoading = true;
    _isLoadingMore = false;
    _errorMessage = null;
    _currentPage = 1;
    _totalPages = 1;
    _photos.clear();
    notifyListeners();

    try {
      final response = await _unsplashService.searchPhotos(_query, 1);
      _photos
        ..clear()
        ..addAll(response.photos);
      _totalPages = response.totalPages;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshPhotos() async {
    if (_query.isEmpty) return;
    await fetchPhotos(_query);
  }

  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !hasMore || _query.isEmpty) return;

    _isLoadingMore = true;
    _errorMessage = null;
    notifyListeners();

    final nextPage = _currentPage + 1;
    try {
      final response = await _unsplashService.searchPhotos(_query, nextPage);
      _photos.addAll(response.photos);
      _currentPage = nextPage;
      _totalPages = response.totalPages;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
