import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveTheme(_isDarkMode);
    notifyListeners(); // ✅ Fixes the error!
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners(); // ✅ Fixes the error!
  }

  Future<void> _saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }
}
