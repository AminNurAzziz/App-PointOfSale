import 'package:flutter/material.dart';

import 'package:pos_aplication/Services/ServicesPendapatan.dart';
import 'package:pos_aplication/Model/ModelPendapatan.dart';

class ProviderPendapatan extends ChangeNotifier {
  final ServicesPendapatan _pendapatanService = ServicesPendapatan();
  List<Pendapatan> _pendapatan = [];

  List<Pendapatan> get pendapatan => _pendapatan;

  Future<void> fetchPendapatan() async {
    try {
      print('Fetching pendapatan...');

      final pendapatan = await _pendapatanService.fetchPendapatan();
      print('Fetched pendapatan: $pendapatan');

      _pendapatan = pendapatan;
      notifyListeners();
    } catch (e) {
      print('Error fetching pendapatan: $e');
    }
  }
}
