import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemePreference { system, light, dark }

class ThemeProvider extends ChangeNotifier {
  static const String _key = 'theme_preference';

  ThemePreference _preference = ThemePreference.system;

  ThemePreference get preference => _preference;

  ThemeMode get themeMode {
    switch (_preference) {
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
      case ThemePreference.system:
        return ThemeMode.system;
    }
  }

  ThemeProvider() {
    _load();
  }

  Future<void> setPreference(ThemePreference preference) async {
    _preference = preference;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, preference.name);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    ThemePreference? value;
    for (final mode in ThemePreference.values) {
      if (mode.name == raw) {
        value = mode;
        break;
      }
    }
    if (value != null) {
      _preference = value;
      notifyListeners();
    }
  }
}
