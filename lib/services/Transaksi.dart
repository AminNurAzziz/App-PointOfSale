import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Transaksi {
  List<Map<String, dynamic>> idProduk = [];

  final String? idAdmin;

  Transaksi({
    required this.idProduk,
    this.idAdmin,
  });
}

class TransaksiService {
  static const baseUrl = "http://192.168.178.135:3000";

  Future<void> addTransaksi(Transaksi transaksi) async {
    final response = await http.post(
      Uri.parse("$baseUrl/addTransaksi"),
      headers: {
        'Content-Type': 'application/json', // Pastikan menambahkan header ini
      },
      body: jsonEncode({
        'idProduk': transaksi.idProduk, // Kirim sebagai array objek
        'idAdmin': '876543210987654321098765', // Sesuaikan ini sesuai kebutuhan
      }),
    );
  }
}
