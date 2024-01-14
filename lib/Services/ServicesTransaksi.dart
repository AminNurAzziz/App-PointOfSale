import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pos_aplication/Model/ModelTransaksi.dart';

class ServiceTransaksi {
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
