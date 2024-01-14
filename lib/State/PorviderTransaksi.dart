import 'package:flutter/material.dart';
import 'package:pos_aplication/Services/ServicesTransaksi.dart';
import 'package:pos_aplication/Model/ModelTransaksi.dart';

class ProviderTransaksi extends ChangeNotifier {
  final ServiceTransaksi _transaksiService = ServiceTransaksi();
  List<Transaksi> _transaksi = [];

  List<Transaksi> get transaksi => _transaksi;

  Future<void> addTransaksi(Transaksi transaksi) async {
    try {
      await _transaksiService.addTransaksi(transaksi);
      await fetchTransaksi();
    } catch (error) {
      throw Exception('Failed to add transaksi: $error');
    }
  }

  Future<void> fetchTransaksi() async {
    try {
      _transaksi = await _transaksiService.getTransaksi();
      print(await _transaksiService.getTransaksi());
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to fetch transaksi: $error');
    }
  }

  List<Transaksi> getFilteredAndSortedTransaksi(
    List<Transaksi> transaksi,
    String selectedCategory,
    String selectedSortOption,
    String selectedFoodSortOption,
    String selectedBeverageSortOption,
    bool isSortAscending,
  ) {
    List<Transaksi> filteredTransaksi = transaksi;

    if (selectedCategory != 'All') {
      filteredTransaksi = filteredTransaksi
          .where((t) => t.idProduk
              .any((produk) => produk['kategoriProduk'] == selectedCategory))
          .toList();
    }

    // Apply sorting based on the selected option
    if (selectedCategory == 'All') {
      if (selectedSortOption == 'Harga') {
        filteredTransaksi
            .sort((a, b) => a.totalHarga!.compareTo(b.totalHarga!) ?? 0);
      } else if (selectedSortOption == 'Tanggal') {
        filteredTransaksi.sort((a, b) =>
            a.tanggalTransaksi!.compareTo(b.tanggalTransaksi!) == 0
                ? a.waktu!.compareTo(b.waktu!)
                : a.tanggalTransaksi!.compareTo(b.tanggalTransaksi!));
      }
    } else if (selectedCategory == 'Makanan') {
      if (selectedFoodSortOption == 'Harga') {
        filteredTransaksi
            .sort((a, b) => a.totalHarga!.compareTo(b.totalHarga!) ?? 0);
      } else if (selectedFoodSortOption == 'Tanggal') {
        filteredTransaksi.sort((a, b) =>
            a.tanggalTransaksi!.compareTo(b.tanggalTransaksi!) == 0
                ? a.waktu!.compareTo(b.waktu!)
                : a.tanggalTransaksi!.compareTo(b.tanggalTransaksi!));
      }
    } else if (selectedCategory == 'Minuman') {
      if (selectedBeverageSortOption == 'Harga') {
        filteredTransaksi
            .sort((a, b) => a.totalHarga!.compareTo(b.totalHarga!) ?? 0);
      } else if (selectedBeverageSortOption == 'Tanggal') {
        filteredTransaksi.sort((a, b) =>
            a.tanggalTransaksi!.compareTo(b.tanggalTransaksi!) == 0
                ? a.waktu!.compareTo(b.waktu!)
                : a.tanggalTransaksi!.compareTo(b.tanggalTransaksi!));
      }
    }

    // Reverse the list if sorting in descending order
    if (!isSortAscending) {
      filteredTransaksi = filteredTransaksi.reversed.toList();
    }

    return filteredTransaksi;
  }
}
