import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:pos_aplication/Services/ServicesProducts.dart';
import 'package:pos_aplication/State/ProviderProducts.dart';
import 'package:pos_aplication/Model/ModelProduct.dart';

class ProductsFormWidget extends StatefulWidget {
  const ProductsFormWidget({Key? key}) : super(key: key);

  @override
  State<ProductsFormWidget> createState() => _ProductsFormWidgetState();
}

class _ProductsFormWidgetState extends State<ProductsFormWidget> {
  TextEditingController _namaController = TextEditingController();
  TextEditingController _hargaController = TextEditingController();
  TextEditingController _stokController = TextEditingController();
  String selectedKategori = 'Makanan'; // Kategori default
  TextEditingController _gambarController = TextEditingController();
  XFile? selectedImage; // Variable untuk menyimpan gambar yang dipilih

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image;
    });
  }

  void _submitForm() {
    // Anda bisa melakukan tindakan untuk mengirim data produk ke server atau yang lainnya di sini
    String namaProduk = _namaController.text;
    double hargaProduk = double.tryParse(_hargaController.text) ?? 0.0;
    int stokProduk = int.tryParse(_stokController.text) ?? 0;
    String kategoriProduk = selectedKategori;
    String gambarProduk = _gambarController.text != "" ? 'nulll' : 'null11';

    ServicesProduct produk = ServicesProduct();
    Product newProduct = Product(
      name: namaProduk,
      price: hargaProduk,
      stock: stokProduk,
      category: kategoriProduk,
      imageUrl: gambarProduk,
    );
    // produk.addProduct(newProduct);
    Provider.of<ProviderProduct>(context, listen: false).addProduct(newProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft, // Teks "Tambah Produk" ke kiri
          child: Text(
            'Tambah Produk',
            style: TextStyle(fontSize: 24.0),
            textAlign: TextAlign.left,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            _pickImage(); // Pilih gambar setelah lokasi diperoleh
          },
          child: Text('Pilih Gambar'),
        ),
        if (selectedImage != null) ...[
          SizedBox(height: 20),
          Image.file(
            File(selectedImage!.path),
            height: 100,
            width: 150,
          ),
        ],
        TextFormField(
          controller: _namaController,
          decoration: InputDecoration(labelText: 'Nama Produk'),
        ),
        TextFormField(
          controller: _hargaController,
          decoration: InputDecoration(labelText: 'Harga Produk'),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: _stokController,
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
          onPressed: _submitForm,
          child: Text('Tambah Produk'),
        ),
      ],
    );
  }
}
