import 'package:event_media_viewer/core/constants.dart';
import 'package:event_media_viewer/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService(this._client);

  final SupabaseClient _client;

  Future<List<EventModel>> fetchEvents() async {
    final response = await _client
        .from(AppConstants.eventsTable)
        .select('id, name, code')
        .order('name');

    return (response as List<dynamic>)
        .map((item) => EventModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> addEvent({required String name, required String code}) async {
    await _client.from(AppConstants.eventsTable).insert({
      'name': name.trim(),
      'code': code.trim().toUpperCase(),
    });
  }
}
