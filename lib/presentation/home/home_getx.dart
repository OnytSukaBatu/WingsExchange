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

  TextEditingController controller = TextEditingController();

  RxDouble asetValue = 0.0.obs;
  RxBool showAset = false.obs;
  RxList<AsetEntity> listMarket = <AsetEntity>[].obs;

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
    showAset.value = !showAset.value;
  }

  Future<void> onRefresh() async {
    await onGetUserData();
    await onGetListMarket();
  }

  Future<void> onGetListMarket() async {
    await dioUsecase.getListMarket().then((value) {
      value.fold((left) {}, (right) {
        listMarket.value = right;
      });
    });

    isMarketDataLoading.value = false;
  }

  Future<void> onGetUserData() async {
    List userData = [];
    String email = f.boxRead(key: MainConfig.stringEmail);

    List<num> priceData = <num>[];

    await firebaseUsecase.getUserData(email: email).then((value) {
      value.fold((left) {}, (right) {
        priceData.add(double.parse(right.rupiah));
        userData = jsonDecode(right.data);
      });
    });

    for (Map<String, dynamic> i in userData) {
      num? currentPrice;

      await dioUsecase.getAsetPrice(id: i['id']).then((value) {
        value.fold((left) {}, (right) {
          currentPrice = right;
        });
      });

      if (currentPrice == null) return;

      priceData.add(
        f.getPrice(
          oldPrice: i['price'],
          totalAset: i['aset'],
          newPrice: currentPrice?.toDouble() ?? 0,
        ),
      );
    }

    asetValue.value = priceData.reduce((a, b) => a + b).toDouble();
    isUserDataLoading.value = false;
  }
}
