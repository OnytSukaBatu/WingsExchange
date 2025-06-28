import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_email.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/domain/usecases/firebase_usecase.dart';
import 'package:wings/injection_container.dart';
import 'package:wings/presentation/pin/pin_page.dart';

class ResetGetx extends GetxController {
  FirebaseUsecase usecase = injection<FirebaseUsecase>();

  TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String email = f.boxRead(key: MainConfig.stringEmail);

  Timer? timer;
  RxInt remainingTime = 0.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  @override
  void onClose() {
    super.onClose();
    if (timer != null) timer?.cancel();
  }

  void init() async {
    f.onShowLoading();
    await FuncE.send(email);
    f.onEndLoading();

    if (timer != null) timer?.cancel();
    remainingTime.value = 180;

    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (remainingTime.value == 0) {
        timer?.cancel();
        return;
      }

      remainingTime.value--;
    });
  }

  void onValidate() async {
    if (!globalKey.currentState!.validate()) return;
    bool isValidate = FuncE.verify(controller.text);

    if (isValidate) {
      f.onShowLoading();
      await usecase.getUserData(email: email).then((value) {
        f.onEndLoading();

        value.fold(
          (left) {
            f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal mendapatkan data pengguna');
          },
          (right) async {
            String? newPin = await Get.to(() => PinPage(), arguments: PINmethod.create);

            if (newPin == null || newPin.isEmpty) {
              f.onShowWarn('Gagal mendapatkan PIN');
              return;
            }

            Map<String, String> updateData = {'pin': newPin};

            f.onShowLoading();
            await usecase.updateUserData(uid: right.id, data: updateData).then((value) {
              f.onEndLoading();

              value.fold(
                (left) {
                  f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal update data pengguna');
                },
                (right) async {
                  f.onShowLoading();
                  await f.secureWrite(key: MainConfig.stringPIN, value: newPin);
                  await Future.delayed(const Duration(seconds: 2));
                  f.onEndLoading();

                  Get.offAll(() => PinPage(), arguments: PINmethod.secure);
                },
              );
            });
          },
        );
      });
    } else {
      f.onShowWarn('OTP tidak valid');
    }
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) return 'OTP Kosong!';
    if (value.length != 6) return 'Masukan OTP yang valid';
    return null;
  }

  String format(int value) {
    int menit = value ~/ 60;
    int detik = value % 60;
    String formatDetik = detik.toString().padLeft(2, '0');
    return '$menit:$formatDetik';
  }
}
