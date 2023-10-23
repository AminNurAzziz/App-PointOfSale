import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;
  void addToCart(Map<String, dynamic> product) {
    final existingProductIndex =
        _cart.indexWhere((item) => item['id'] == product['id']);

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
