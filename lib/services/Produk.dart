import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  final String? id;
  final String name;
  final double price;
  final int stock;
  final String category;
  final String imageUrl;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.imageUrl,
  });
}

class Produk {
  static const baseUrl = "http://192.168.178.135:3000";

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse("$baseUrl/tambahProduk"),
      body: {
        'namaProduk': product.name,
        'hargaProduk': product.price.toString(),
        'stokProduk': product.stock.toString(),
        'kategoriProduk': product.category,
        'gambarProduk': product.imageUrl,
        'idAdmin': await getIdAdmin(),
      },
    );
    print(response.body);
  }

  Future<String?> getIdAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = json.decode(
            utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
        final userId = payload['userId'];
        return userId;
      }
    }

    return null;
  }

  Future<List<Product>> fetchProducts(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/produk'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['error'] == false) {
        final productList = List<Map<String, dynamic>>.from(data['data']);
        return productList
            .map((productMap) => Product(
                  id: productMap['_id'],
                  name: productMap['namaProduk'],
                  price: productMap['hargaProduk'].toDouble(),
                  stock: productMap['stokProduk'],
                  category: productMap['kategoriProduk'],
                  imageUrl: productMap['gambarProduk'],
                ))
            .toList();
      } else {
        throw Exception('Failed to fetch products: ${data['message']}');
      }
    } else {
      throw Exception('Failed to fetch products: HTTP ${response.statusCode}');
    }
  }
}
