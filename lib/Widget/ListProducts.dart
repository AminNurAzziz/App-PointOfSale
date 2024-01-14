import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_aplication/Widget/CardProducts.dart';
import 'package:pos_aplication/Services/data_dummy.dart';
import 'package:pos_aplication/Services/CardProvider.dart';
import 'package:pos_aplication/Services/Produk.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({Key? key}) : super(key: key);

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  List<Product> products = [];
  String tokenFromAuth = '';
  Produk produk = Produk();

  @override
  void initState() {
    super.initState();
    tokenFromAuth = Provider.of<CartProvider>(context, listen: false).token;
    if (tokenFromAuth != '') {
      produk.fetchProducts(tokenFromAuth).then((value) {
        setState(() {
          products = value;
        });
      });
    } else {
      getTokenFromLocalStorage().then((token) {
        if (token != null) {
          // fetchData(token);
          produk.fetchProducts(token).then((value) {
            setState(() {
              products = value;
            });
          });
        }
      });
    }
  }

  Future<String?> getTokenFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  void onTapCart(int index) {
    Provider.of<CartProvider>(context, listen: false).addToCart({
      'idProduk': products[index].id, // Ganti dengan atribut ID yang sesuai
      'namaProduk': products[index].name,
      'hargaProduk': products[index].price,
      'gambarProduk': products[index].imageUrl,
      'jumlahProduk': 1,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Barang 1 berhasil ditambahkan ke keranjang'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
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
                          // Gambar
                          Image.asset(
                            'assets/chicken.jpg',
                            // product['gambarProduk']
                            //     as String, // Path gambar produk
                            width:
                                80, // Sesuaikan lebar gambar sesuai kebutuhan
                            height:
                                50, // Sesuaikan tinggi gambar sesuai kebutuhan
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${product.name}",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
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
                          ),
                          Spacer(),
                          Text(
                            "Rp. ${product.price}",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          CartProducts(),
        ],
      ),
    );
  }
}
