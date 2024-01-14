import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderAuth extends ChangeNotifier {
  String _token = '';

  String get token => _token;

  // Method to set the token value
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _token = token;
    notifyListeners();
  }
}
