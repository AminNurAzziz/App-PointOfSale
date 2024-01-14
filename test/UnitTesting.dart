import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pos_aplication/Services/ServicesProducts.dart';

void main() {
  group('Produk', () {
    setUp(() async {
      // Inisialisasi SharedPreferences untuk pengujian
      SharedPreferences.setMockInitialValues({'token': '{"idAdmin": "1"}'});
    });

    test('getIdAdmin should return idAdmin from SharedPreferences', () async {
      // Buat instance dari Produk
      final produk = ServicesProduct();

      // Panggil metode getIdAdmin
      final idAdmin = await produk.getIdAdmin();

      // Cetak nilai idAdmin
      print('idAdmin: $idAdmin');

      // Verifikasi bahwa metode getIdAdmin menghasilkan hasil yang diharapkan
      expect(idAdmin, '1');
    });
  });
}
