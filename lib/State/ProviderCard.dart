import 'package:flutter/material.dart';

class ProviderCart extends ChangeNotifier {
  List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

  void addToCart(Map<String, dynamic> product) {
    final existingProductIndex =
        _cart.indexWhere((item) => item['idProduk'] == product['idProduk']);

    if (existingProductIndex != -1) {
      _cart[existingProductIndex]['jumlahProduk'] += 1;
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
