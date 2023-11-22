import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pos_aplication/Services/ServicesProducts.dart';
import 'package:pos_aplication/Model/ModelProduct.dart';

class ProviderProduct extends ChangeNotifier {
  final ServicesProduct _produkService = ServicesProduct();
  List<Product> _products = [];

  List<Product> get products => _products;

  // Fungsi untuk menambah produk
  Future<void> addProduct(Product product) async {
    try {
      await _produkService.addProduct(product);
      // Refresh daftar produk setelah penambahan
      await fetchProducts();
    } catch (error) {
      throw Exception('Failed to add product: $error');
    }
  }

  // Fungsi untuk mengambil daftar produk
  Future<void> fetchProducts([String? token]) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenn = prefs.getString('token');
      final updatedToken = tokenn ?? token;
      _products = await _produkService.fetchProducts(updatedToken!);
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to fetch products: $error');
    }
  }

  // Fungsi untuk mengambil detail produk
  Future<void> fetchProductDetail(String id) async {
    try {
      Product product = await _produkService.detailProduct(id);
      // Tampilkan detail produk sesuai kebutuhan
    } catch (error) {
      throw Exception('Failed to fetch product detail: $error');
    }
  }

  // Fungsi untuk mengedit produk
  Future<void> editProduct(Product product) async {
    try {
      await _produkService.editProducts(product);
      // Refresh daftar produk setelah pengeditan
      await fetchProducts();
    } catch (error) {
      throw Exception('Failed to edit product: $error');
    }
  }

  // Fungsi untuk menghapus produk
  Future<void> deleteProduct(String id) async {
    try {
      print(id);
      await _produkService.deleteProduct(id);
      // Refresh daftar produk setelah penghapusan
      await fetchProducts();
    } catch (error) {
      throw Exception('Failed to delete product: $error');
    }
  }
}
