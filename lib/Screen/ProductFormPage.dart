import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pos_aplication/Widget/ProductsFormAdd.dart';

class Produk extends StatefulWidget {
  const Produk({Key? key}) : super(key: key);

  @override
  State<Produk> createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
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
    String gambarProduk = _gambarController.text;

    // Contoh output data yang akan dicetak ke konsol
    print('Nama Produk: $namaProduk');
    print('Harga Produk: $hargaProduk');
    print('Stok Produk: $stokProduk');
    print('Kategori Produk: $kategoriProduk');
    print('Gambar Produk: $gambarProduk');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ProductsFormWidget(), // Use the widget here
        ),
      ),
    );
  }
}
