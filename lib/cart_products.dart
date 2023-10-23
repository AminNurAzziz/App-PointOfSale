import 'package:flutter/material.dart';
import 'package:pos_aplication/cart_provider.dart';
import 'package:provider/provider.dart';

class CartProducts extends StatefulWidget {
  const CartProducts({Key? key}) : super(key: key);

  @override
  State<CartProducts> createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  @override
  void onTapStruk() {
    Provider.of<CartProvider>(context, listen: false).removeAll();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Semua barang berhasil dihapus'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().cart;
    double total = 0.0;
    for (var i = 0; i < cart.length; i++) {
      total += cart[i]['hargaProduk'] * cart[i]['stok'];
    }
    print(cart);
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 241, 241, 241),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.9),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.75),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 25, // Adjust width as needed
                  child: Text(
                    'No',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 75, // Adjust width as needed
                  child: Text(
                    'Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 75, // Adjust width as needed
                  child: Text(
                    'Jumlah',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 70, // Adjust width as needed
                  child: Text(
                    'Subtotal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                height: cart.length > 5 ? 120 : null,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: cart.length > 5
                      ? AlwaysScrollableScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    var item = cart[index];
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 25, // Adjust width as needed
                              child: Center(
                                child: Text((index + 1).toString(),
                                    style: TextStyle(fontSize: 15)),
                              ),
                            ),
                            Container(
                              width: 80, // Adjust width as needed
                              child: Center(
                                child: Text(item['namaProduk'],
                                    style: TextStyle(fontSize: 15)),
                              ),
                            ),
                            Container(
                              width: 80, // Adjust width as needed
                              child: Center(
                                child: Text(item['stok'].toString(),
                                    style: TextStyle(fontSize: 15)),
                              ),
                            ),
                            Container(
                              width: 80, // Adjust width as needed
                              child: Center(
                                child: Text(
                                    (item['hargaProduk'] * item['stok'])
                                        .toString(),
                                    style: TextStyle(fontSize: 15)),
                              ),
                            ),
                          ],
                        ),
                        if (index != cart.length - 1)
                          Container(
                            height: 0.3,
                            color: Colors.grey,
                            margin: EdgeInsets.all(2),
                          )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          // SizedBox(
          //   height: 5,
          // ),
          Divider(
            color: Colors.grey,
            thickness: 1,
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Rp. ${total.toString()}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: () {
                    onTapStruk();
                  },
                  icon: const Icon(
                    Icons.receipt_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
