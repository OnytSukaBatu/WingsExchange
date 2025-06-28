import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/presentation/dashboard/dashboard_page.dart';

class PinGetx extends GetxController {
  RxString message = ''.obs;
  late PINmethod method;

  RxString value = ''.obs;
  RxString create = ''.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onGetMethod();
    });
  }

  PINmethod getMethod() {
    if (Get.arguments is PINmethod) return Get.arguments;
    Get.back();
    return PINmethod.result;
  }

  void onGetMethod() {
    method = getMethod();
    if (method == PINmethod.result) message.value = 'Masukan PIN Anda';
    if (method == PINmethod.create) message.value = 'Buat PIN Baru';
    if (method == PINmethod.secure) message.value = 'Masukan PIN Anda';
    if (method == PINmethod.confirm) message.value = 'Masukan PIN Anda';
  }

  void onTap(String num) {
    value.value += num;
    if (value.value.length != 6) return;
    if (method == PINmethod.result) Get.back(result: value.value);
    if (method == PINmethod.create) onCreate();
    if (method == PINmethod.secure) onSecure();
    if (method == PINmethod.confirm) onConfirm();
  }

  void onBack() {
    value.value = value.value.substring(0, value.value.length - 1);
  }

  void onHold() {
    value.value = '';
  }

  void onCreate() {
    if (create.value.isNotEmpty) {
      if (value.value == create.value) return Get.back(result: value.value);
      create.value = '';
      value.value = '';
      message.value = 'Buat PIN Baru';
      f.onShowWarn('PIN tidak sama! ulangi buat PIN baru');
    } else {
      create.value = value.value;
      value.value = '';
      message.value = 'Konfirmasi PIN Baru';
    }
  }

  void onSecure() async {
    f.onShowLoading();
    String realValue = await f.secureRead(key: MainConfig.stringPIN);
    f.onEndLoading();

    print('${value.value} == ${realValue}');

    if (value.value == realValue) return Get.offAll(() => DashboardPage());
    value.value = '';

    f.onShowWarn('PIN salah');
  }

  void onConfirm() async {
    f.onShowLoading();
    String realValue = await f.secureRead(key: MainConfig.stringPIN);
    f.onEndLoading();

    if (value.value == realValue) return Get.back(result: true);
    value.value = '';

    f.onShowWarn('PIN salah');
  }
}
