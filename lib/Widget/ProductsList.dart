import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:pos_aplication/State/ProviderAuth.dart';

import 'package:pos_aplication/Widget/ProductsCard.dart';
import 'package:pos_aplication/Model/ModelProduct.dart';
import 'package:pos_aplication/State/ProviderCard.dart';
import 'package:pos_aplication/State/ProviderProducts.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  late List<Product> products;
  late String tokenFromAuth;

  @override
  void initState() {
    super.initState();
    tokenFromAuth = Provider.of<ProviderAuth>(context, listen: false).token;
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    if (tokenFromAuth.isNotEmpty) {
      Provider.of<ProviderProduct>(context, listen: false)
          .fetchProducts(tokenFromAuth);
    } else {
      final token = await getTokenFromLocalStorage();
      if (token != null) {
        Provider.of<ProviderProduct>(context, listen: false)
            .fetchProducts(token);
      }
    }
  }

  Future<String?> getTokenFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void onTapCart(int index) {
    final product = products[index];
    Provider.of<ProviderCart>(context, listen: false).addToCart({
      'idProduk': product.id,
      'namaProduk': product.name,
      'hargaProduk': product.price,
      'gambarProduk': product.imageUrl,
      'jumlahProduk': 1,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} berhasil ditambahkan ke keranjang'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    products = Provider.of<ProviderProduct>(context).products;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return buildProductCard(product, index);
                },
              ),
            ),
            ProductsCart(),
          ],
        ),
      ),
    );
  }

  Widget buildProductCard(Product product, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () {
          onTapCart(index);
        },
        splashColor: const Color.fromARGB(255, 230, 230, 230),
        child: Ink(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 254, 254, 254),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0.5,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              buildProductImage('assets/chicken.jpg'),
              SizedBox(width: 5),
              buildProductDetails(product),
              Spacer(),
              buildProductPrice(product.price),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductImage(String imageUrl) {
    return Image.asset(
      imageUrl, // Path gambar produk
      width: 80,
      height: 50,
    );
  }

  Widget buildProductDetails(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${product.name}",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        Text(
          "${product.stock} in stock",
          style: TextStyle(
            fontSize: 14,
            color: const Color.fromARGB(255, 73, 73, 73),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget buildProductPrice(double price) {
    return Text(
      "Rp. $price",
      style: TextStyle(fontSize: 18, color: Colors.black),
    );
  }
}
