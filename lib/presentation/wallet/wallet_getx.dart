import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/core/main_image_path.dart';
import 'package:wings/data/models/data_model.dart';
import 'package:wings/domain/usecases/dio_usecase.dart';
import 'package:wings/domain/usecases/firebase_usecase.dart';
import 'package:wings/injection_container.dart';

class WalletGetx extends GetxController {
  DioUsecase dioUsecase = injection<DioUsecase>();
  FirebaseUsecase firebaseUsecase = injection<FirebaseUsecase>();

  RxDouble userAset = 0.0.obs;
  RxBool showUserAset = false.obs;
  RxList<DataModel> realListUserAset = <DataModel>[].obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onGetUserData();
    });
  }

  void onShowAset() {
    showUserAset.value = !showUserAset.value;
  }

  Future<void> onGetUserData() async {
    List userData = [];
    String email = f.boxRead(key: MainConfig.stringEmail);

    List<num> priceData = <num>[];
    List<DataModel> tempList = [];

    await firebaseUsecase.getUserData(email: email).then((value) {
      value.fold(
        (left) {
          f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal mendapatkan data pengguna');
        },
        (right) {
          userData = jsonDecode(right.data);

          tempList.add(DataModel(id: 'rupiah-token', price: 1, aset: double.parse(right.rupiah), image: ImagePath.networkRupiah, name: 'Rupiah'));

          priceData.add(double.parse(right.rupiah));
        },
      );
    });

    for (Map<String, dynamic> i in userData) {
      num currentPrice = 0;
      await dioUsecase.getAsetPrice(id: i['id']).then((value) {
        value.fold(
          (left) {
            f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal mendapatkan data aset');
          },
          (right) {
            currentPrice = right;
          },
        );
      });

      double absPrice = f.getPrice(oldPrice: i['price'], totalAset: i['aset'], newPrice: currentPrice.toDouble());
      priceData.add(absPrice);
      DataModel temp = DataModel.fromArray(i);
      tempList.add(DataModel(id: temp.id, price: temp.price, aset: absPrice, image: temp.image, name: temp.name));
    }

    realListUserAset.value = tempList;
    userAset.value = priceData.reduce((a, b) => a + b).toDouble();

    isLoading.value = false;
  }
}
