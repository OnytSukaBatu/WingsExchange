import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_function.dart';
import 'package:dio/dio.dart' as dio;
import 'package:wings/core/main_image_path.dart';
import 'package:wings/core/main_model/data_model.dart';
import 'package:wings/domain/usecases/firebase_usecase.dart';
import 'package:wings/injection_container.dart';

class WalletGetx extends GetxController {
  FirebaseUsecase usecase = injection<FirebaseUsecase>();

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
    List userData = [];
    String email = f.boxRead(key: MainConfig.stringEmail);

    List<num> priceData = <num>[];
    List<DataModel> tempList = [];

    await usecase.getUserData(email: email).then((value) {
      value.fold((left) {}, (right) {
        userData = jsonDecode(right.data);

        tempList.add(
          DataModel(
            id: 'rupiah-token',
            price: 1,
            aset: double.parse(right.rupiah),
            image: ImagePath.networkRupiah,
            name: 'Rupiah',
          ),
        );

        priceData.add(double.parse(right.rupiah));
      });
    });

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

    realData.value = tempList;
    asetValue.value = priceData.reduce((a, b) => a + b).toDouble();

    isLoading.value = false;
  }
}
