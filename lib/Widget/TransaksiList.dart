import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_aplication/State/PorviderTransaksi.dart';
import 'package:pos_aplication/Model/ModelTransaksi.dart';
import 'package:intl/intl.dart';

class TransaksiList extends StatefulWidget {
  const TransaksiList({Key? key}) : super(key: key);

  @override
  State<TransaksiList> createState() => _TransaksiListState();
}

class _TransaksiListState extends State<TransaksiList> {
  String selectedSortOption = '';
  String selectedCategory = 'All';
  String selectedFoodSortOption = '';
  String selectedBeverageSortOption = '';
  bool isSortAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<ProviderTransaksi>(context, listen: false).fetchTransaksi();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Transaksi> transaksi =
        Provider.of<ProviderTransaksi>(context).transaksi;

    List<Transaksi> filteredAndSortedTransaksi =
        Provider.of<ProviderTransaksi>(context).getFilteredAndSortedTransaksi(
      transaksi,
      selectedCategory,
      selectedSortOption,
      selectedFoodSortOption,
      selectedBeverageSortOption,
      isSortAscending,
    );

    int totalFoodProductsSold =
        getTotalProductsSold(filteredAndSortedTransaksi, 'Makanan');
    int totalBeverageProductsSold =
        getTotalProductsSold(filteredAndSortedTransaksi, 'Minuman');
    int totalRevenue = calculateTotalRevenue(filteredAndSortedTransaksi);

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          _buildHeaderCard(
            totalFoodProductsSold,
            totalBeverageProductsSold,
            totalRevenue,
          ),
          SizedBox(height: 16),
          _buildFilterAndSortRow(),
          SizedBox(height: 16),
          Expanded(
            child: filteredAndSortedTransaksi.isEmpty
                ? Center(
                    child: Text(
                      'No transactions available.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredAndSortedTransaksi.length,
                    itemBuilder: (context, index) {
                      Transaksi currentTransaksi =
                          filteredAndSortedTransaksi[index];
                      return _buildTransactionCard(currentTransaksi);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(int totalFoodProductsSold,
      int totalBeverageProductsSold, int totalRevenue) {
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDashboardItem(
              icon: Icons.fastfood,
              title: 'Food Sold',
              value: '$totalFoodProductsSold items',
              color: Colors.green,
            ),
            _buildDashboardItem(
              icon: Icons.local_drink,
              title: 'Beverage Sold',
              value: '$totalBeverageProductsSold items',
              color: Colors.blue,
            ),
            _buildDashboardItem(
              icon: Icons.attach_money,
              title: 'Total Revenue',
              value: currencyFormat.format(totalRevenue),
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterAndSortRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSortPopupMenu(),
        _buildCategoryFilterDropdown(),
      ],
    );
  }

  Widget _buildSortPopupMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          if (value == 'Reset') {
            // Reset sorting
            selectedSortOption = '';
            isSortAscending = true;
          } else {
            if (selectedSortOption == value) {
              // Toggle between ascending and descending order
              isSortAscending = !isSortAscending;
            } else {
              // If a different option is selected, default to ascending order
              selectedSortOption = value;
              isSortAscending = true;
            }
          }
        });
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'Harga',
          child: Row(
            children: [
              Text('Harga'),
              Spacer(),
              Icon(
                isSortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 20, // Adjust the size as needed
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Tanggal',
          child: Row(
            children: [
              Text('Tanggal'),
              Spacer(),
              Icon(
                isSortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 20, // Adjust the size as needed
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Reset',
          child: Row(
            children: [
              Text('Reset'),
              // Optionally, you can add an icon for the reset option
            ],
          ),
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.sort),
            Text(
              selectedSortOption.isEmpty ? 'Sort by' : ' $selectedSortOption',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox.fromSize(size: Size(8, 0)),
            Icon(
              isSortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 20, // Adjust the size as needed
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilterDropdown() {
    return Row(
      children: [
        Text('Category: '),
        SizedBox(width: 8),
        DropdownButton<String>(
          value: selectedCategory,
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue!;
            });
          },
          items: ['All', 'Makanan', 'Minuman']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(Transaksi currentTransaksi) {
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Card(
      elevation: 3,
      margin: EdgeInsets.all(6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ExpansionTile(
        title: Text(
          currencyFormat.format(currentTransaksi.totalHarga),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        subtitle: Text(
          'Tanggal: ${currentTransaksi.tanggalTransaksi} - Waktu ${currentTransaksi.waktu}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Produk:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                for (var produkMap in currentTransaksi.idProduk)
                  ListTile(
                    leading: Image.asset(
                      'assets/chicken.jpg',
                      width: 80,
                      height: 100,
                    ),
                    title: Text(
                      'Nama: ${produkMap['namaProduk']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 58, 58, 58),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Harga: ${currencyFormat.format(produkMap['hargaProduk'])}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Jumlah: ${produkMap['jumlahProduk']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Sub Total: ${currencyFormat.format(produkMap['subTotalProduk'])}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(
      {required IconData icon,
      required String title,
      required String value,
      required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 32,
          color: color,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  int getTotalProductsSold(List<Transaksi> transaksi, String kategori) {
    return transaksi
        .expand((t) => t.idProduk)
        .where((produk) => produk['kategoriProduk'] == kategori)
        .fold(0, (sum, produk) => sum + (produk['jumlahProduk'] as int));
  }

  int calculateTotalRevenue(List<Transaksi> transaksi) {
    return transaksi.fold(
        0,
        (total, transaksi) =>
            total +
            transaksi.idProduk
                .where((produk) =>
                    selectedCategory == 'All' ||
                    produk['kategoriProduk'] == selectedCategory)
                .fold(
                    0,
                    (subtotal, produk) =>
                        subtotal + (produk['subTotalProduk'] as int)));
  }
}
