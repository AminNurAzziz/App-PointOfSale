import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pos_aplication/Model/ModelProduct.dart';

class ServicesProduct {
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

  Future<Product> detailProduct(String id) async {
    print(id);
    final response = await http.get(
      Uri.parse('$baseUrl/produk/$id'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['error'] == false) {
        // Assuming 'data' contains the details of the product
        final productData =
            data['data']; // Assuming 'data' is a Map<String, dynamic>
        return Product(
          id: productData['_id'],
          name: productData['namaProduk'],
          price: productData['hargaProduk'].toDouble(),
          stock: productData['stokProduk'],
          category: productData['kategoriProduk'],
          imageUrl: productData['gambarProduk'],
        );
      } else {
        throw Exception('Failed to detail product: ${data['message']}');
      }
    } else {
      throw Exception('Failed to detail product: HTTP ${response.statusCode}');
    }
  }

  Future<void> editProducts(Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/updateProduk/${product.id}'),
      body: {
        'namaProduk': product.name,
        'hargaProduk': product.price.toString(),
        'stokProduk': product.stock.toString(),
        'kategoriProduk': product.category,
        'gambarProduk': product.imageUrl,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['error'] == false) {
        return;
      } else {
        throw Exception('Failed to edit product: ${data['message']}');
      }
    } else {
      throw Exception('Failed to edit product: HTTP ${response.statusCode}');
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/deleteProduk/$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['error'] == false) {
        return;
      } else {
        throw Exception('Failed to delete product: ${data['message']}');
      }
    } else {
      throw Exception('Failed to delete product: HTTP ${response.statusCode}');
    }
  }
}
