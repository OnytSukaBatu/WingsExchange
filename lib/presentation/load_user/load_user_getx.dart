import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/domain/usecases/dio_usecase.dart';
import 'package:wings/domain/usecases/firebase_usecase.dart';
import 'package:wings/injection_container.dart';
import 'package:wings/presentation/pin/pin_page.dart';
import 'package:wings/presentation/register/register_page.dart';

class LoadUserGetx extends GetxController {
  DioUsecase dioUsecase = injection<DioUsecase>();
  FirebaseUsecase firebaseUsecase = injection<FirebaseUsecase>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onCheckUser();
    });
  }

  void onCheckUser() async {
    String email = f.boxRead(key: MainConfig.stringEmail);

    await firebaseUsecase.getApiKey().then((value) {
      value.fold(
        (left) {
          f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal mendapatkan data kunci sistem');
        },
        (right) async {
          await f.secureWrite(key: MainConfig.stringApiKey, value: right);
        },
      );
    });

    await firebaseUsecase.getUserData(email: email).then((value) {
      value.fold(
        (left) {
          Get.offAll(() => RegisterPage());
        },
        (right) async {
          await f.secureWrite(key: MainConfig.stringPIN, value: right.pin);
          await f.boxWrite(key: MainConfig.stringDisplay, value: right.display);
          await f.boxWrite(key: MainConfig.boolLogin, value: true);

          Get.offAll(() => PinPage(), arguments: PINmethod.secure);
        },
      );
    });
  }
}
