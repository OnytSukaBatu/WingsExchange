import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_function.dart';
import 'package:dio/dio.dart' as dio;
import 'package:wings/core/main_model/data_model.dart';

class WalletGetx extends GetxController {
  List data = jsonDecode(f.boxRead(key: MainConfig.stringTransaction));
  RxDouble asetValue = 0.0.obs;
  RxBool showAset = false.obs;
  RxList<DataModel> realData = <DataModel>[].obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onGetUserData();
    });
  }

  void onShowAset() {
    showAset.value = !showAset.value;
  }

  Future<void> onGetUserData() async {
    await f.onGetUserData();
    data = jsonDecode(f.boxRead(key: MainConfig.stringTransaction));

    List<num> priceData = <num>[];
    List<DataModel> tempList = [];

    for (Map<String, dynamic> i in data) {
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
      double absPrice = f.getPrice(
        oldPrice: i['price'],
        totalAset: i['aset'],
        newPrice: currentPrice.toDouble(),
      );
      priceData.add(absPrice);
      DataModel temp = DataModel.fromMap(i);
      tempList.add(
        DataModel(
          id: temp.id,
          price: temp.price,
          aset: absPrice,
          image: temp.image,
          name: temp.name,
        ),
      );
    }
    tempList.add(
      DataModel(
        id: 'rupiah-token',
        price: 1,
        aset: double.parse(f.boxRead(key: MainConfig.stringRupiah)),
        image:
            'https://coin-images.coingecko.com/coins/images/9441/large/57421944_1371636006308255_3647136573922738176_n.jpg?1696509533',
        name: 'Rupiah',
      ),
    );
    realData.value = tempList;
    priceData.add(double.parse(f.boxRead(key: MainConfig.stringRupiah)));
    asetValue.value = priceData.reduce((a, b) => a + b).toDouble();

    isLoading.value = false;
  }
}
