import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/fundamental/main_config.dart';
import 'package:wings/fundamental/main_function.dart';
import 'package:wings/fundamental/main_model/aset_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:wings/fundamental/main_model/data_model.dart';

class TransactionGetx extends GetxController {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late AsetModel aset;
  TextEditingController controller = TextEditingController();
  Timer? timer;
  List data = jsonDecode(f.boxRead(key: MainConfig.stringTransaction));

  RxInt resetIn = 60.obs;
  RxDouble fee = 0.0.obs;
  RxDouble finalPrice = 0.0.obs;
  RxDouble myCoin = 0.0.obs;
  RxDouble rupiah = 0.0.obs;
  RxDouble currentPrice = 0.0.obs;
  RxBool isDone = false.obs;
  RxBool onBuy = true.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      onGetArguments();
      await onGetData();
      onGetDataEveryMinute();
    });
  }

  @override
  void onClose() {
    super.onClose();
    timer?.cancel();
  }

  void onGetArguments() {
    if (Get.arguments is AsetModel) {
      aset = Get.arguments;
      currentPrice.value = aset.currentPrice.toDouble();
      rupiah.value = double.parse(f.boxRead(key: MainConfig.stringRupiah));
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

    int index = data.indexWhere((item) => item['id'] == aset.id);
    if (index == -1) return;
    myCoin.value = f.getPrice(
      oldPrice: data[index]['price'],
      totalAset: data[index]['aset'],
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

  void onChanged(String value) {
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
    int index = data.indexWhere((item) => item['id'] == id);
    double asetBaru = finalPrice.value;

    if (index != -1) {
      Map<String, dynamic> item = data[index];
      data[index] = DataModel(
        id: id,
        price: item['price'],
        aset: item['aset'] + asetBaru,
        image: aset.image,
        name: aset.name,
      ).toMap();
    } else {
      data.add(
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
    Map<Object, Object> updateData = {
      'data': jsonEncode(data),
      'rupiah': sisaSaldo,
    };

    await FirebaseFirestore.instance
        .collection('main-user')
        .doc(uid)
        .update(updateData);

    await f.boxWrite(key: MainConfig.stringRupiah, value: sisaSaldo);
    await f.boxWrite(key: MainConfig.stringTransaction, value: data.toString());

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
    int index = data.indexWhere((item) => item['id'] == aset.id);
    double sisaAset = myCoin.value - inputHarga;

    if (sisaAset < 100) {
      data.removeAt(index);
    } else {
      data[index] = DataModel(
        id: aset.id,
        price: currentPrice.value,
        aset: f.doubleD(sisaAset),
        image: aset.image,
        name: aset.name,
      ).toMap();
    }

    rupiah.value = f.doubleD(rupiah.value + finalPrice.value);
    String stringData = jsonEncode(data);
    String uid = await f.secureRead(key: MainConfig.stringID);

    await FirebaseFirestore.instance.collection('main-user').doc(uid).update({
      'data': stringData,
      'rupiah': '${rupiah.value}',
    });

    await f.boxWrite(key: MainConfig.stringRupiah, value: '${rupiah.value}');
    await f.boxWrite(key: MainConfig.stringTransaction, value: stringData);

    f.onEndLoading();
    Get.back();
    f.onShowSnackbar(
      title: 'Transaksi Berhasil!',
      message: 'Menjual ${f.numFormat(inputHarga, symbol: 'Rp')} ${aset.id}',
    );
  }
}
