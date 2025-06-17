import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/fundamental/main_function.dart';
import 'package:wings/fundamental/main_widget.dart';
import 'package:wings/page_n_state/transaction/transaction_getx.dart';

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
        title: w.text(
          data: 'Transaksi',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => getx.isDone.value
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 32,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: getx.aset.image,
                              ),
                            ),
                          ),
                          w.gap(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              w.text(
                                data: getx.aset.name,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              w.text(data: getx.aset.id, fontSize: 12),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              w.text(
                                data: 'Nilai ${getx.aset.name}',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              Obx(
                                () => w.text(
                                  data: f.numFormat(
                                    getx.currentPrice.value,
                                    symbol: 'Rp',
                                  ),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      w.gap(height: 16),
                      Container(
                        height: 160,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Obx(
                          () => LineChart(
                            curve: Curves.easeOutQuart,
                            duration: const Duration(seconds: 2),
                            LineChartData(
                              titlesData: FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: List.generate(
                                    getx.chartData.length,
                                    (index) => FlSpot(
                                      index.toDouble(),
                                      getx.chartData[index],
                                    ),
                                  ),
                                  isCurved: false,
                                  color: Colors.blue,
                                  barWidth: 1,
                                  belowBarData: BarAreaData(show: false),
                                  dotData: FlDotData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      w.gap(height: 5),
                      Row(
                        children: [
                          w.text(data: 'Weekly Chart ${getx.aset.name} by'),
                          w.gap(width: 2),
                          w.text(
                            data: 'Coingecko',
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    backgroundColor: Colors.transparent,
                  ),
                ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: w.button(
                  // onPressed: getx.onBeli,
                  onPressed: () {
                    getx.onViewTransaction(isBuy: true);
                  },
                  backgroundColor: Colors.green,
                  borderColor: Colors.black,
                  child: w.text(
                    data: 'Beli',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              w.gap(width: 16),
              Expanded(
                child: w.button(
                  // onPressed: getx.onJual,
                  onPressed: () {
                    getx.onViewTransaction(isBuy: false);
                  },
                  backgroundColor: Colors.red,
                  borderColor: Colors.black,
                  child: w.text(
                    data: 'jual',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
