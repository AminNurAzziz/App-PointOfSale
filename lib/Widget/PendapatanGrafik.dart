import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:pos_aplication/State/ProviderPendapatan.dart';
import 'package:pos_aplication/Model/ModelPendapatan.dart';
import 'package:intl/intl.dart';

class PendapatanGrafik extends StatefulWidget {
  const PendapatanGrafik({Key? key}) : super(key: key);

  @override
  State<PendapatanGrafik> createState() => _PendapatanGrafikState();
}

class _PendapatanGrafikState extends State<PendapatanGrafik> {
  late List<Pendapatan> pendapatan = [];
  List<Color> colorList = [
    Color(0xFF006400),
    Color(0xFF004400)
  ]; // Warna hijau tua
  double shortBarThreshold =
      50.0; // Nilai batas tinggi batang untuk mengubah warna label

  @override
  void initState() {
    super.initState();
    _fetchPendapatan();
  }

  Future<void> _fetchPendapatan() async {
    await Provider.of<ProviderPendapatan>(context, listen: false)
        .fetchPendapatan();
    pendapatan =
        Provider.of<ProviderPendapatan>(context, listen: false).pendapatan;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 500,
      child: Column(
        children: [
          Text(
            'Grafik Pendapatan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          // Jika pendapatan kosong, tampilkan indikator loading
          pendapatan.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(child: _buildChart()),
        ],
      ),
    );
  }

  charts.BarChart _buildChart() {
    var series = [
      charts.Series<Pendapatan, String>(
        id: 'Pendapatan',
        data: pendapatan,
        domainFn: (Pendapatan pendapatan, _) {
          DateTime? dateTime = pendapatan.tanggalPendapatan != null
              ? DateTime.tryParse(pendapatan.tanggalPendapatan!)
              : null;

          return dateTime != null ? DateFormat('MMM dd').format(dateTime) : '';
        },
        measureFn: (Pendapatan pendapatan, _) => pendapatan.totalPendapatan,
        colorFn: (_, index) => charts.ColorUtil.fromDartColor(
            colorList[index! % colorList.length]),
        labelAccessorFn: (Pendapatan pendapatan, _) {
          final formatCurrency =
              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

          // Periksa tinggi batang, jika kurang dari batas tertentu, ganti warna label menjadi putih
          if (pendapatan.totalPendapatan! < shortBarThreshold) {
            return formatCurrency.format(pendapatan.totalPendapatan);
          } else {
            return formatCurrency.format(pendapatan.totalPendapatan) + ' ';
          }
        },
      ),
    ];

    return charts.BarChart(
      series,
      animate: true,
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(
        outsideLabelStyleSpec: charts.TextStyleSpec(
          color: charts.MaterialPalette.black,
          fontSize: 12,
        ),
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontSize: 12,
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontSize: 12,
          ),
          lineStyle: charts.LineStyleSpec(
            thickness: 0,
          ),
        ),
      ),
    );
  }
}
