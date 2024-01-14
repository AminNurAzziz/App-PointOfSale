import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pos_aplication/Model/ModelPendapatan.dart';

class ServicesPendapatan {
  static const baseUrl = "http://192.168.178.135:3000";

  Future<List<Pendapatan>> fetchPendapatan() async {
    final response = await http.get(
      Uri.parse('$baseUrl/pendapatan'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['error'] == false) {
        final pendapatanList = List<Map<String, dynamic>>.from(data['data']);

        return pendapatanList
            .map((pendapatanMap) => Pendapatan(
                  id: pendapatanMap['_id'],
                  totalPendapatan: pendapatanMap['totalPendapatan'].toDouble(),
                  tanggalPendapatan: pendapatanMap['tanggalPendapatan'],
                ))
            .toList();
      } else {
        throw Exception('Error in API response: ${data['message']}');
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }
}
