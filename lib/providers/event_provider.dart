import 'package:event_media_viewer/models/event_model.dart';
import 'package:event_media_viewer/services/supabase_service.dart';
import 'package:flutter/foundation.dart';

class EventProvider extends ChangeNotifier {
  EventProvider({required SupabaseService supabaseService})
    : _supabaseService = supabaseService;

  final SupabaseService _supabaseService;

  List<EventModel> _events = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _events = await _supabaseService.fetchEvents();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshEvents() async {
    await fetchEvents();
  }

  Future<bool> addEvent({required String name, required String code}) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _supabaseService.addEvent(name: name, code: code);
      await fetchEvents();
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
