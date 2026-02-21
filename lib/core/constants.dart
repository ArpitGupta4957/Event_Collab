import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  static String get supabaseUrl => _requireEnv('SUPABASE_URL');
  static String get supabaseAnonKey => _requireEnv('SUPABASE_ANON_KEY');
  static String get unsplashApiKey => _requireEnv('UNSPLASH_API_KEY');

  static const String eventsTable = 'events';
  static const int photosPerPage = 20;

  static String _requireEnv(String key) {
    final value = dotenv.env[key]?.trim() ?? '';
    if (value.isEmpty) {
      throw Exception('Missing required environment variable: $key');
    }
    return value;
  }
}
