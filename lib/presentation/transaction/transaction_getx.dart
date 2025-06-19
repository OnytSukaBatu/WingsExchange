import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/core/main_model/aset_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:wings/core/main_model/data_model.dart';
import 'package:wings/core/main_widget.dart';
import 'package:wings/domain/usecases/firebase_usecase.dart';
import 'package:wings/injection_container.dart';

class TransactionGetx extends GetxController {
  FirebaseUsecase usecase = injection<FirebaseUsecase>();

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late AsetModel aset;
  TextEditingController controller = TextEditingController();
  Timer? timer;
  List userData = [];

  RxInt resetIn = 60.obs;
  RxDouble fee = 0.0.obs;
  RxDouble finalPrice = 0.0.obs;
  RxDouble myCoin = 0.0.obs;
  RxDouble rupiah = 0.0.obs;
  RxDouble currentPrice = 0.0.obs;
  RxBool isDone = false.obs;
  RxBool onBuy = true.obs;
  RxList<double> chartData = <double>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await onGetArguments();
      await onGetChart();
      await onGetData();
      onGetDataEveryMinute();
    });
  }

  @override
  void onClose() {
    super.onClose();
    timer?.cancel();
  }

  Future<void> onGetArguments() async {
    if (Get.arguments is AsetModel) {
      aset = Get.arguments;
      currentPrice.value = aset.currentPrice.toDouble();

      String email = f.boxRead(key: MainConfig.stringEmail);

      await usecase.getUserData(email: email).then((value) {
        value.fold((left) {}, (right) {
          rupiah.value = double.parse(right.rupiah);
          userData = jsonDecode(right.data);
        });
      });
    } else {
      Get.back();
    }
  }

  Future<void> onGetData() async {
    dio.Response respose = await dio.Dio().get(
      'https://api.coingecko.com/api/v3/simple/price?vs_currencies=idr&ids=${aset.id}',
      options: dio.Options(
        headers: {
          'x-cg-demo-api-key': await f.secureRead(key: MainConfig.stringApiKey),
        },
      ),
    );
    Map<String, dynamic> responseData = respose.data;
    num price = responseData[aset.id]['idr'];
    currentPrice.value = price.toDouble();

    isDone.value = true;

    int index = userData.indexWhere((item) => item['id'] == aset.id);
    if (index == -1) return;
    myCoin.value = f.getPrice(
      oldPrice: userData[index]['price'],
      totalAset: userData[index]['aset'],
      newPrice: currentPrice.value,
    );
  }

  Future<void> onGetDataEveryMinute() async {
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (resetIn.value > 0) {
        resetIn.value--;
      } else {
        onGetData();
        resetIn.value = 60;
      }
    });
  }

  Future<void> onGetChart() async {
    dio.Response chartResponse = await dio.Dio().get(
      'https://api.coingecko.com/api/v3/coins/${aset.id}/market_chart?vs_currency=idr&days=7&interval=daily',
      options: dio.Options(
        headers: {
          'x-cg-demo-api-key': await f.secureRead(key: MainConfig.stringApiKey),
        },
      ),
    );

    Map<String, dynamic> responseDataChart = chartResponse.data;
    List rawData = responseDataChart['prices'];

    for (List i in rawData) {
      chartData.add(i[1]);
    }
  }

  void onChanged(String value) {
    if (value.isEmpty) {
      finalPrice.value = 0;
      return;
    }
    int input = int.parse(value);
    fee.value = input * 0.0125;
    finalPrice.value = input * 0.9875;
  }

  String? onValidatorTransaction(String? value) {
    if (value == null || value.isEmpty) return 'Tidak ada nilai transaksi!';

    double numValue = double.parse(value);

    if (onBuy.value) {
      if (numValue > rupiah.value) return 'Saldo tidak cukup!';
    } else {
      if (numValue > myCoin.value) return 'Aset tidak cukup!';
    }

    return null;
  }

  void onBeli() async {
    onBuy.value = true;
    if (!globalKey.currentState!.validate()) return;
    f.onShowLoading();

    double inputHarga = double.parse(controller.text);
    String id = aset.id;
    int index = userData.indexWhere((item) => item['id'] == id);
    double asetBaru = finalPrice.value;

    if (index != -1) {
      Map<String, dynamic> item = userData[index];
      userData[index] = DataModel(
        id: id,
        price: item['price'],
        aset: item['aset'] + asetBaru,
        image: aset.image,
        name: aset.name,
      ).toMap();
    } else {
      userData.add(
        DataModel(
          id: id,
          price: currentPrice.value,
          aset: asetBaru,
          image: aset.image,
          name: aset.name,
        ).toMap(),
      );
    }

    String uid = await f.secureRead(key: MainConfig.stringID);
    String sisaSaldo = (rupiah.value - inputHarga).toString();

    Map<String, String> newData = {
      'data': jsonEncode(userData),
      'rupiah': sisaSaldo,
    };

    await usecase.updateUserData(uid: uid, data: newData).then((value) {
      value.fold((left) {}, (right) {});
    });

    f.onEndLoading();
    Get.back();
    f.onShowSnackbar(
      title: 'Transaksi Berhasil!',
      message: 'Membeli ${f.numFormat(asetBaru, symbol: 'Rp')} $id',
    );
  }

  void onJual() async {
    onBuy.value = false;
    if (!globalKey.currentState!.validate()) return;
    f.onShowLoading();

    double inputHarga = double.parse(controller.text);
    int index = userData.indexWhere((item) => item['id'] == aset.id);
    double sisaAset = myCoin.value - inputHarga;

    if (sisaAset < 100) {
      userData.removeAt(index);
    } else {
      userData[index] = DataModel(
        id: aset.id,
        price: currentPrice.value,
        aset: f.doubleD(sisaAset),
        image: aset.image,
        name: aset.name,
      ).toMap();
    }

    rupiah.value = f.doubleD(rupiah.value + finalPrice.value);
    String stringData = jsonEncode(userData);
    String uid = await f.secureRead(key: MainConfig.stringID);
    Map<String, String> newData = {
      'data': stringData,
      'rupiah': '${rupiah.value}',
    };

    await usecase.updateUserData(uid: uid, data: newData).then((value) {
      value.fold((left) {}, (right) {});
    });

    f.onEndLoading();
    Get.back();
    f.onShowSnackbar(
      title: 'Transaksi Berhasil!',
      message: 'Menjual ${f.numFormat(inputHarga, symbol: 'Rp')} ${aset.id}',
    );
  }

  void onViewTransaction({required bool isBuy}) {
    f.onShowBottomSheet(
      backgroundColor: Colors.white,
      padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
      borderRadius: BorderRadius.zero,
      child: Container(
        width: Get.width,
        child: Obx(
          () => Form(
            key: globalKey,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: Get.back,
                      icon: Icon(Icons.arrow_back),
                    ),
                    w.gap(width: 5),
                    w.text(
                      data: '${isBuy ? 'Pembelian' : 'Penjualan'} ${aset.name}',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    w.text(
                      data: 'Nilai ${aset.name}',
                      fontWeight: FontWeight.bold,
                    ),
                    w.text(
                      data: f.numFormat(currentPrice.value, symbol: 'Rp'),
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(
                    () => w.text(
                      data: 'diupdate dalam (${resetIn.value})',
                      fontSize: 12,
                    ),
                  ),
                ),
                w.gap(height: 16),
                w.field(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  label: w.text(
                    data: 'Nilai Transaksi',
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  onChanged: onChanged,
                  validator: onValidatorTransaction,
                ),
                w.gap(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Visibility(
                    visible: isBuy,
                    child: w.text(
                      data: 'Saldo Rupiah Anda ${f.numFormat(rupiah.value)}',
                      fontSize: 12,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Visibility(
                    visible: !isBuy,
                    child: w.text(
                      data:
                          'Saldo ${aset.name} Anda ${f.numFormat(myCoin.value, symbol: 'Rp')}',
                      fontSize: 12,
                    ),
                  ),
                ),
                w.gap(height: 16),
                Visibility(
                  visible: finalPrice.value > 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          w.text(
                            data: 'Biaya transaksi (1.25%) :',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          Spacer(),
                          w.text(
                            data: f.numFormat(fee.value, symbol: 'Rp'),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          w.text(
                            data: 'Aset yang anda terima :',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          Spacer(),
                          w.text(
                            data: f.numFormat(finalPrice.value, symbol: 'Rp'),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      w.button(
                        onPressed: () {
                          onPressPrecentage(percent: .25, isBuy: isBuy);
                        },
                        backgroundColor: Colors.white,
                        borderColor: Colors.black,
                        child: w.text(data: '25%', fontSize: 12),
                      ),
                      w.button(
                        onPressed: () {
                          onPressPrecentage(percent: .5, isBuy: isBuy);
                        },
                        backgroundColor: Colors.white,
                        borderColor: Colors.black,
                        child: w.text(data: '50%', fontSize: 12),
                      ),
                      w.button(
                        onPressed: () {
                          onPressPrecentage(percent: .75, isBuy: isBuy);
                        },
                        backgroundColor: Colors.white,
                        borderColor: Colors.black,
                        child: w.text(data: '75%', fontSize: 12),
                      ),
                      w.button(
                        onPressed: () {
                          onPressPrecentage(percent: 1, isBuy: isBuy);
                        },
                        backgroundColor: Colors.white,
                        borderColor: Colors.black,
                        child: w.text(data: '100%', fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: w.button(
                    onPressed: () {
                      Get.back();
                      isBuy ? onBeli() : onJual();
                    },
                    backgroundColor: Colors.black,
                    child: w.text(
                      data: isBuy ? 'Beli' : 'Jual',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPressPrecentage({required double percent, required bool isBuy}) {
    double value = (isBuy ? rupiah.value : myCoin.value) * percent;
    controller.text = value.toStringAsFixed(0);
    onChanged(controller.text);
  }
}
