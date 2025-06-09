import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wings/fundamental/main_config.dart';
import 'package:wings/fundamental/main_function.dart';
import 'package:wings/fundamental/main_model/aset_model.dart';

class HomeGetx extends GetxController {
  TextEditingController controller = TextEditingController();
  List userData = jsonDecode(f.boxRead(key: MainConfig.stringTransaction));

  RxDouble asetValue = 0.0.obs;
  RxBool showAset = false.obs;
  RxList<AsetModel> listMarket = <AsetModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await onGetUserData();
      await onGetListMarket();
    });
  }

  void onShowAset() {
    showAset.value = !showAset.value;
  }

  Future<void> onRefresh() async {
    await onGetUserData();
    await onGetListMarket();
  }

  Future<void> onGetListMarket() async {
    dio.Response<dynamic> response = await dio.Dio().get(
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=idr',
      options: dio.Options(
        headers: {
          'x-cg-demo-api-key': await f.secureRead(key: MainConfig.stringApiKey),
        },
      ),
    );
    List<dynamic> responseData = response.data;
    listMarket.value = responseData
        .map((item) => AsetModel.fromMap(item))
        .toList();
  }

  Future<void> onGetUserData() async {
    await f.onGetUserData();
    userData = jsonDecode(f.boxRead(key: MainConfig.stringTransaction));
    List<num> priceData = <num>[];
    for (Map<String, dynamic> i in userData) {
      dio.Response respose = await dio.Dio().get(
        'https://api.coingecko.com/api/v3/simple/price?vs_currencies=idr&ids=${i['id']}',
        options: dio.Options(
          headers: {
            'x-cg-demo-api-key': await f.secureRead(
              key: MainConfig.stringApiKey,
            ),
          },
        ),
      );
      Map<String, dynamic> responseData = respose.data;
      num currentPrice = responseData[i['id']]['idr'];
      priceData.add(
        f.getPrice(
          oldPrice: i['price'],
          totalAset: i['aset'],
          newPrice: currentPrice.toDouble(),
        ),
      );
    }
    priceData.add(double.parse(f.boxRead(key: MainConfig.stringRupiah)));
    asetValue.value = priceData.reduce((a, b) => a + b).toDouble();
  }
}
