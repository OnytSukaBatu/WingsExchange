import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/core/main_widget.dart';
import 'package:wings/data/models/data_model.dart';
import 'package:wings/domain/entities/aset_entity.dart';
import 'package:wings/domain/usecases/dio_usecase.dart';
import 'package:wings/domain/usecases/firebase_usecase.dart';
import 'package:wings/injection_container.dart';

class TransactionGetx extends GetxController {
  DioUsecase dioUsecase = injection<DioUsecase>();
  FirebaseUsecase firebaseUsecase = injection<FirebaseUsecase>();

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late AsetEntity aset;
  TextEditingController controller = TextEditingController();
  Timer? timer;
  List userData = [];

  RxInt updateIn = 60.obs;
  RxDouble feeTransaction = 0.0.obs;
  RxDouble finalPrice = 0.0.obs;
  RxDouble myCoin = 0.0.obs;
  RxDouble myRupiah = 0.0.obs;
  RxDouble currentAsetPrice = 0.0.obs;
  RxBool isLoading = true.obs;
  RxBool onBuy = true.obs;
  RxList<double> chartData = <double>[].obs;

  String uid = '';

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
    if (Get.arguments is AsetEntity) {
      aset = Get.arguments;
      currentAsetPrice.value = aset.currentPrice.toDouble();

      String email = f.boxRead(key: MainConfig.stringEmail);

      await firebaseUsecase.getUserData(email: email).then((value) {
        value.fold(
          (left) {
            f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal mendapatkan data pengguna');
          },
          (right) {
            uid = right.id;
            myRupiah.value = double.parse(right.rupiah);
            userData = jsonDecode(right.data);
          },
        );
      });
    } else {
      Get.back();
    }
  }

  Future<void> onGetData() async {
    await dioUsecase.getAsetPrice(id: aset.id).then((value) {
      value.fold(
        (left) {
          currentAsetPrice.value = 0;
          f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal mendapatkan data harga aset');
        },
        (right) {
          currentAsetPrice.value = right.toDouble();
        },
      );
    });

    isLoading.value = false;

    int index = userData.indexWhere((item) => item['id'] == aset.id);
    if (index == -1) return;
    myCoin.value = f.getPrice(oldPrice: userData[index]['price'], totalAset: userData[index]['aset'], newPrice: currentAsetPrice.value);
  }

  Future<void> onGetDataEveryMinute() async {
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (updateIn.value > 0) {
        updateIn.value--;
      } else {
        onGetData();
        updateIn.value = 60;
      }
    });
  }

  Future<void> onGetChart() async {
    List rawData = [];

    await dioUsecase.getAsetChart(id: aset.id, days: 30).then((value) {
      value.fold(
        (left) {
          f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal mendapatkan data chart aset');
        },
        (right) {
          rawData = right;
        },
      );
    });

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
    feeTransaction.value = input * 0.001;
    finalPrice.value = input * 0.999;
  }

  String? onValidatorTransaction(String? value) {
    if (value == null || value.isEmpty) return 'Tidak ada nilai transaksi!';

    double numValue = double.parse(value);

    print('-xxx- $numValue ${myRupiah.value} ${myCoin.value}');

    if (onBuy.value) {
      if (numValue > myRupiah.value) return 'Saldo tidak cukup!';
    } else {
      if (numValue > myCoin.value) return 'Aset tidak cukup!';
    }
    return null;
  }

  void onBeli() async {
    double inputHarga = double.parse(controller.text);
    int index = userData.indexWhere((item) => item['id'] == aset.id);
    double asetDibeli = finalPrice.value;

    if (index != -1) {
      Map<String, dynamic> item = userData[index];
      userData[index] = DataModel(id: aset.id, price: item['price'], aset: item['aset'] + asetDibeli, image: aset.image, name: aset.name).toArray();
    } else {
      userData.add(DataModel(id: aset.id, price: currentAsetPrice.value, aset: asetDibeli, image: aset.image, name: aset.name).toArray());
    }

    String sisaSaldo = (myRupiah.value - inputHarga).toString();
    Map<String, String> updateData = {'data': jsonEncode(userData), 'rupiah': sisaSaldo};

    f.onShowLoading();
    await firebaseUsecase.updateUserData(uid: uid, data: updateData).then((value) {
      f.onEndLoading();

      value.fold(
        (left) {
          Get.back();
          f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal membeli aset');
        },
        (right) {
          Get.back();
          f.onShowSnackbar(
            title: 'Transaksi Berhasil!',
            message: 'Membeli ${f.numFormat(asetDibeli, symbol: 'Rp')} ${aset.id}',
          );
        },
      );
    });
  }

  void onJual() async {
    double inputHarga = double.parse(controller.text);
    int index = userData.indexWhere((item) => item['id'] == aset.id);
    double sisaAset = myCoin.value - inputHarga;

    if (sisaAset < 1) {
      userData.removeAt(index);
    } else {
      userData[index] = DataModel(id: aset.id, price: currentAsetPrice.value, aset: f.doubleD(sisaAset), image: aset.image, name: aset.name).toArray();
    }

    myRupiah.value = f.doubleD(myRupiah.value + finalPrice.value);
    String stringData = jsonEncode(userData);
    Map<String, String> updateData = {'data': stringData, 'rupiah': '${myRupiah.value}'};

    f.onShowLoading();
    await firebaseUsecase.updateUserData(uid: uid, data: updateData).then((value) {
      f.onEndLoading();

      value.fold(
        (left) {
          Get.back();
          f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal menjual aset');
        },
        (right) {
          Get.back();
          f.onShowSnackbar(
            title: 'Transaksi Berhasil!',
            message: 'Menjual ${f.numFormat(inputHarga, symbol: 'Rp')} ${aset.id}',
          );
        },
      );
    });
  }

  void onViewTransaction({required bool isBuy}) {
    onBuy.value = isBuy;

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
                    IconButton(onPressed: Get.back, icon: Icon(Icons.arrow_back)),
                    w.gap(width: 5),
                    w.text(data: '${isBuy ? 'Pembelian' : 'Penjualan'} ${aset.name}', fontWeight: FontWeight.bold, fontSize: 16),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    w.text(data: 'Nilai ${aset.name}', fontWeight: FontWeight.bold),
                    w.text(
                      data: f.numFormat(currentAsetPrice.value, symbol: 'Rp'),
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(() => w.text(data: 'diupdate dalam (${updateIn.value})', fontSize: 12)),
                ),
                w.gap(height: 16),
                w.field(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  label: w.text(data: 'Nilai Transaksi', fontSize: 12, color: Colors.black),
                  onChanged: onChanged,
                  validator: onValidatorTransaction,
                ),
                w.gap(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Visibility(
                    visible: isBuy,
                    child: w.text(data: 'Saldo Rupiah Anda ${f.numFormat(myRupiah.value)}', fontSize: 12),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Visibility(
                    visible: !isBuy,
                    child: w.text(data: 'Saldo ${aset.name} Anda ${f.numFormat(myCoin.value, symbol: 'Rp')}', fontSize: 12),
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
                          w.text(data: 'Biaya transaksi (0.1%) :', fontSize: 12, fontWeight: FontWeight.bold),
                          Spacer(),
                          w.text(
                            data: f.numFormat(feeTransaction.value, symbol: 'Rp'),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          w.text(data: 'Aset yang anda terima :', fontSize: 12, fontWeight: FontWeight.bold),
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
                          onPressPercentage(percent: .25, isBuy: isBuy);
                        },
                        backgroundColor: Colors.white,
                        borderColor: Colors.black,
                        child: w.text(data: '25%', fontSize: 12),
                      ),
                      w.button(
                        onPressed: () {
                          onPressPercentage(percent: .5, isBuy: isBuy);
                        },
                        backgroundColor: Colors.white,
                        borderColor: Colors.black,
                        child: w.text(data: '50%', fontSize: 12),
                      ),
                      w.button(
                        onPressed: () {
                          onPressPercentage(percent: .75, isBuy: isBuy);
                        },
                        backgroundColor: Colors.white,
                        borderColor: Colors.black,
                        child: w.text(data: '75%', fontSize: 12),
                      ),
                      w.button(
                        onPressed: () {
                          onPressPercentage(percent: 1, isBuy: isBuy);
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
                      if (!globalKey.currentState!.validate()) return;
                      Get.back();
                      isBuy ? onBeli() : onJual();
                    },
                    backgroundColor: Colors.black,
                    child: w.text(data: isBuy ? 'Beli' : 'Jual', fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPressPercentage({required double percent, required bool isBuy}) {
    double value = (isBuy ? myRupiah.value : myCoin.value) * percent;
    controller.text = value.toInt().toString();
    onChanged(controller.text);
  }
}
