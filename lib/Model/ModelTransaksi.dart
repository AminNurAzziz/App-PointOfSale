class Transaksi {
  List<Map<String, dynamic>> idProduk = [];

  final String? idAdmin;

  Transaksi({
    required this.idProduk,
    this.idAdmin,
  });
}
