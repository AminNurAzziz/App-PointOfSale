import 'package:flutter/material.dart';
import 'package:pos_aplication/Screen/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cart = [];
  String _token = '';

  String get token => _token;
  // Metode untuk mengatur nilai _token
  void setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token: $prefs');
    _token = token;
    notifyListeners(); // Memberi tahu listener bahwa nilai _token telah berubah
  }

  List<Map<String, dynamic>> get cart => _cart;
  void addToCart(Map<String, dynamic> product) {
    final existingProductIndex =
        _cart.indexWhere((item) => item['id'] == product['id']);
    // print('====================================================');
    // print(existingProductIndex);
    // print('====================================================');

    if (existingProductIndex != -1) {
      _cart[existingProductIndex]['stok'] += 1;
      print(_cart[existingProductIndex]['stok']);
    } else {
      _cart.add(product);
    }

    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> product) {
    _cart.remove(product);
    notifyListeners();
  }

  void removeAll() {
    _cart.clear();
    notifyListeners();
  }
}
