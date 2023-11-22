import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:pos_aplication/Screen/HomePage.dart';
import 'package:pos_aplication/State/ProviderProducts.dart';
import 'package:pos_aplication/Model/ModelProduct.dart';

class ProductsManage extends StatefulWidget {
  const ProductsManage({Key? key}) : super(key: key);

  @override
  State<ProductsManage> createState() => _ProductsManageState();
}

class _ProductsManageState extends State<ProductsManage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    getTokenFromLocalStorage().then((token) {
      if (token != null) {
        Provider.of<ProviderProduct>(context, listen: false)
            .fetchProducts(token);
      }
    });
  }

  Future<String?> getTokenFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  void onTap(int index) {
    Provider.of<ProviderProduct>(context, listen: false)
        .deleteProduct(products[index].id.toString());

    setState(() {
      products.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produk berhasil dihapus'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    products = Provider.of<ProviderProduct>(context).products;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
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
                        width: 80,
                        height: 50,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${products[index].name}",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Stock ${products[index].stock}",
                              style: TextStyle(
                                fontSize: 13,
                                color: const Color.fromARGB(255, 73, 73, 73),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: 10), // Add some space between text and icons
                      Text(
                        "Rp. ${products[index].price}",
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                index: 3,
                                productId: products[index].id.toString(),
                              ),
                            ),
                          );
                        },
                      ),

                      IconButton(
                        icon: Icon(Icons.delete),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        color: Colors.red,
                        onPressed: () {
                          onTap(index);
                          // Handle delete action
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
