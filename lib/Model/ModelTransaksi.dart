class Transaksi {
  List<Map<String, dynamic>> idProduk = [];

  final String? idAdmin;
  final String? idTransaksi;
  final String? tanggalTransaksi;
  final String? waktu;
  final int? totalHarga;
  final int? jumlahItem;

  Transaksi({
    required this.idProduk,
    this.idAdmin,
    this.idTransaksi,
    this.tanggalTransaksi,
    this.waktu,
    this.totalHarga,
    this.jumlahItem,
  });
}
