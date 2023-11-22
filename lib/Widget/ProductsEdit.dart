import 'package:flutter/material.dart';
import 'package:pos_aplication/Screen/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pos_aplication/Services/ServicesProducts.dart';
import 'package:pos_aplication/Model/ModelProduct.dart';

class ProductsEditWidget extends StatefulWidget {
  final String? productId;
  const ProductsEditWidget({Key? key, required this.productId})
      : super(key: key);

  @override
  State<ProductsEditWidget> createState() => _ProductsEditWidgetState();
}

class _ProductsEditWidgetState extends State<ProductsEditWidget> {
  String selectedKategori = 'Makanan'; // Kategori default
  ServicesProduct produk = ServicesProduct();
  late TextEditingController namaController;
  late TextEditingController hargaController;
  late TextEditingController stokController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    namaController = TextEditingController();
    hargaController = TextEditingController();
    stokController = TextEditingController();
    // Fetch product details and set them in the form fields
    setInit();
  }

  Future<void> setInit() async {
    final token = await getTokenFromLocalStorage();
    if (token != null) {
      try {
        final productDetails = await produk.detailProduct(widget.productId!);
        print('ini product details');
        setState(() {
          // Set product details in the form fields
          namaController.text = productDetails.name;
          hargaController.text = productDetails.price.toString();
          stokController.text = productDetails.stock.toString();
          selectedKategori = productDetails.category!;
        });
      } catch (error) {
        print('Error fetching product details: $error');
      }
    }
  }

  Future<String?> getTokenFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _submitForm() async {
    // Anda bisa melakukan tindakan untuk mengirim data produk ke server atau yang lainnya di sini
    String namaProduk = namaController.text;
    double hargaProduk = hargaController.text != ""
        ? double.tryParse(hargaController.text) ?? 0.0
        : 0.0;
    int stokProduk =
        stokController.text != "" ? int.tryParse(stokController.text) ?? 0 : 0;
    String kategoriProduk = selectedKategori;
    String gambarProduk = 'null11';
    print('ini gambar produk $kategoriProduk');

    ServicesProduct produk = ServicesProduct();
    Product newProduct = Product(
      id: widget.productId,
      name: namaProduk,
      price: hargaProduk,
      stock: stokProduk,
      category: kategoriProduk,
      imageUrl: gambarProduk,
    );
    await produk.editProducts(newProduct);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produk berhasil diedit'),
        duration: Duration(seconds: 1),
      ),
    );

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage(
        index: 2,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Edit Produk',
            style: TextStyle(fontSize: 24.0),
            textAlign: TextAlign.left,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            // Implement image selection logic
          },
          child: Text('Pilih Gambar'),
        ),
        TextFormField(
          controller: namaController,
          decoration: InputDecoration(labelText: 'Nama Produk'),
        ),
        TextFormField(
          controller: hargaController,
          decoration: InputDecoration(labelText: 'Harga Produk'),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: stokController,
          decoration: InputDecoration(labelText: 'Stok Produk'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.0),
        DropdownButtonFormField<String>(
          value: selectedKategori,
          onChanged: (String? newValue) {
            setState(() {
              selectedKategori = newValue!;
            });
          },
          items: <String>['Makanan', 'Minuman', 'Lainnya']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: 'Kategori',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.0),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            _submitForm();
          },
          child: Text('Edit Produk'),
        ),
      ],
    );
  }
}
