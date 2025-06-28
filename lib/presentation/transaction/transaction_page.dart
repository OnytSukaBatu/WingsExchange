import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/core/main_image_path.dart';
import 'package:wings/core/main_widget.dart';
import 'package:wings/presentation/transaction/transaction_getx.dart';

class TransactionPage extends StatelessWidget {
  TransactionPage({super.key});

  final TransactionGetx getx = Get.put(TransactionGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: Get.back, icon: Icon(Icons.arrow_back)),
        title: w.text(data: 'Transaksi', fontWeight: FontWeight.bold, fontSize: 16),
      ),
      body: SafeArea(
        child: Obx(
          () => getx.isLoading.value
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      w.text(data: 'Memuat data..'),
                      w.gap(height: 8),
                      SizedBox(
                        width: 160,
                        child: LinearProgressIndicator(color: Colors.black, backgroundColor: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 32,
                            child: ClipOval(child: CachedNetworkImage(imageUrl: getx.aset.image)),
                          ),
                          w.gap(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              w.text(data: getx.aset.name, fontSize: 16, fontWeight: FontWeight.bold),
                              w.text(data: getx.aset.id, fontSize: 12),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              w.text(data: 'Nilai ${getx.aset.name}', fontSize: 16, fontWeight: FontWeight.bold),
                              Obx(() => w.text(data: f.numFormat(getx.currentAsetPrice.value, symbol: 'Rp'), fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      w.gap(height: 16),
                      Container(
                        height: 160,
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: widgetChart(),
                      ),
                      w.gap(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          w.text(data: 'Harga ${getx.aset.name} 30 hari terkahir'),
                          SizedBox(height: 18, child: Image.asset(ImagePath.coinGecko_dark)),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(
            () => Row(
              children: [
                Expanded(
                  child: w.button(
                    onPressed: getx.isLoading.value ? null : () => getx.onViewTransaction(isBuy: true),
                    backgroundColor: Colors.green,
                    borderColor: Colors.black,
                    child: w.text(data: 'Beli', color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                w.gap(width: 16),
                Expanded(
                  child: w.button(
                    onPressed: getx.isLoading.value ? null : () => getx.onViewTransaction(isBuy: false),
                    backgroundColor: Colors.red,
                    borderColor: Colors.black,
                    child: w.text(data: 'jual', color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetChart() {
    return Obx(
      () => LineChart(
        LineChartData(
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(getx.chartData.length, (index) => FlSpot(index.toDouble(), getx.chartData[index])),
              isCurved: true,
              color: Colors.blue,
              barWidth: 1,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: false),
            ),
          ],
          lineTouchData: LineTouchData(touchTooltipData: toolTipData(), getTouchedSpotIndicator: spotIndicator),
        ),
      ),
    );
  }

  LineTouchTooltipData toolTipData() {
    return LineTouchTooltipData(
      getTooltipColor: (_) => Colors.black,
      tooltipPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      tooltipBorderRadius: BorderRadius.circular(5),
      getTooltipItems: (List<LineBarSpot> listSpot) {
        return listSpot.map((LineBarSpot spot) {
          TextStyle style = GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white);
          return LineTooltipItem(f.numFormat(spot.y), style);
        }).toList();
      },
    );
  }

  List<TouchedSpotIndicatorData> spotIndicator(LineChartBarData barData, List<int> indicators) {
    return indicators.map((index) {
      return TouchedSpotIndicatorData(
        FlLine(color: Colors.transparent),
        FlDotData(
          show: true,
          getDotPainter: (p0, p1, p2, p3) {
            return FlDotCirclePainter(color: Colors.blue, radius: 5);
          },
        ),
      );
    }).toList();
  }
}
