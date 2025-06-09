import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/fundamental/main_config.dart';
import 'package:wings/fundamental/main_function.dart';
import 'package:wings/fundamental/main_widget.dart';
import 'package:wings/page_n_state/dashboard/dashboard_page.dart';

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

  void onGetMethod() {
    if (Get.arguments is PINmethod) {
      method = Get.arguments;
      if (method == PINmethod.result) message.value = 'Masukan PIN Anda';
      if (method == PINmethod.create) message.value = 'Buat PIN Baru';
      if (method == PINmethod.secure) message.value = 'Masukan PIN Anda';
    } else {
      Get.back();
    }
  }

  void onTap(String num) {
    value.value += num;
    if (value.value.length < 6) return;
    if (method == PINmethod.result) Get.back(result: value.value);
    if (method == PINmethod.create) onCreate();
    if (method == PINmethod.secure) onSecure();
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
      f.onShowDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            w.gap(height: 16),
            w.text(data: 'PIN tidak sama! ulangi buat PIN baru'),
            w.gap(height: 5),
            w.button(
              onPressed: Get.back,
              backgroundColor: Colors.white,
              borderColor: Colors.black,
              child: w.text(data: 'Mengerti'),
            ),
            w.gap(height: 16),
          ],
        ),
      );
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

    if (value.value == realValue) return Get.offAll(() => DashboardPage());
    value.value = '';

    f.onShowDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          w.gap(height: 16),
          w.text(data: 'PIN salah'),
          w.gap(height: 5),
          w.button(
            onPressed: Get.back,
            backgroundColor: Colors.white,
            borderColor: Colors.black,
            child: w.text(data: 'Mengerti'),
          ),
          w.gap(height: 16),
        ],
      ),
    );
  }
}
