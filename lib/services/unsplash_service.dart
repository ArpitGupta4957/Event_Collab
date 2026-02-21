import 'dart:convert';

import 'package:event_media_viewer/core/constants.dart';
import 'package:event_media_viewer/models/photo_model.dart';
import 'package:http/http.dart' as http;

class UnsplashSearchResponse {
  const UnsplashSearchResponse({
    required this.photos,
    required this.totalPages,
  });

  final List<PhotoModel> photos;
  final int totalPages;
}

class UnsplashService {
  Future<UnsplashSearchResponse> searchPhotos(String query, int page) async {
    final uri = Uri.https('api.unsplash.com', '/search/photos', {
      'query': query,
      'page': '$page',
      'per_page': '${AppConstants.photosPerPage}',
      'orientation': 'portrait',
    });

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Client-ID ${AppConstants.unsplashApiKey}'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch photos. (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final results = (body['results'] as List<dynamic>?) ?? [];

    return UnsplashSearchResponse(
      photos: results
          .map((item) => PhotoModel.fromMap(item as Map<String, dynamic>))
          .toList(),
      totalPages: (body['total_pages'] as num?)?.toInt() ?? 1,
    );
  }
}
