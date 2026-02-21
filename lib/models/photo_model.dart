class PhotoModel {
  const PhotoModel({
    required this.id,
    required this.thumbUrl,
    required this.regularUrl,
    required this.fullUrl,
    required this.photographer,
    this.description,
  });

  final String id;
  final String thumbUrl;
  final String regularUrl;
  final String fullUrl;
  final String photographer;
  final String? description;

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    final urls = (map['urls'] as Map<String, dynamic>?) ?? {};
    final user = (map['user'] as Map<String, dynamic>?) ?? {};

    return PhotoModel(
      id: map['id']?.toString() ?? '',
      thumbUrl: urls['small']?.toString() ?? '',
      regularUrl: urls['regular']?.toString() ?? '',
      fullUrl: urls['full']?.toString() ?? '',
      photographer: user['name']?.toString() ?? 'Unknown',
      description:
          map['description']?.toString() ?? map['alt_description']?.toString(),
    );
  }
}
