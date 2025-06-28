import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/domain/entities/aset_entity.dart';
import 'package:wings/domain/usecases/dio_usecase.dart';
import 'package:wings/domain/usecases/firebase_usecase.dart';
import 'package:wings/injection_container.dart';

class HomeGetx extends GetxController {
  FirebaseUsecase firebaseUsecase = injection<FirebaseUsecase>();
  DioUsecase dioUsecase = injection<DioUsecase>();

  RxDouble userAset = 0.0.obs;
  RxBool showUserAset = false.obs;
  RxList<AsetEntity> listAsetMarket = <AsetEntity>[].obs;

  RxBool isUserDataLoading = true.obs;
  RxBool isMarketDataLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await onGetUserData();
      await onGetListMarket();
    });
  }

  void onShowAset() {
    showUserAset.value = !showUserAset.value;
  }

  Future<void> onRefresh() async {
    await onGetUserData();
    await onGetListMarket();
  }

  Future<void> onGetListMarket() async {
    await dioUsecase.getListMarket().then((value) {
      value.fold(
        (left) {
          f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal mendapatkan data market');
        },
        (right) {
          listAsetMarket.value = right;
        },
      );
    });

    isMarketDataLoading.value = false;
  }

  Future<void> onGetUserData() async {
    String email = f.boxRead(key: MainConfig.stringEmail);
    List userData = [];
    List<num> priceData = <num>[];

    await firebaseUsecase.getUserData(email: email).then((value) {
      value.fold(
        (left) {
          f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal mendapatkan data pengguna');
        },
        (right) {
          priceData.add(double.parse(right.rupiah));
          userData = jsonDecode(right.data);
        },
      );
    });

    for (Map<String, dynamic> i in userData) {
      num? currentPrice;

      await dioUsecase.getAsetPrice(id: i['id']).then((value) {
        value.fold(
          (left) {
            f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal mendapatkan data harga aset');
          },
          (right) {
            currentPrice = right;
          },
        );
      });

      if (currentPrice == null) return;

      priceData.add(f.getPrice(oldPrice: i['price'], totalAset: i['aset'], newPrice: currentPrice?.toDouble() ?? 0));
    }

    userAset.value = priceData.reduce((a, b) => a + b).toDouble();
    isUserDataLoading.value = false;
  }
}
