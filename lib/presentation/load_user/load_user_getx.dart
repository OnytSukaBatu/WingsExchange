import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/domain/usecases/firebase_usecase.dart';
import 'package:wings/injection_container.dart';
import 'package:wings/presentation/pin/pin_page.dart';
import 'package:wings/presentation/register/register_page.dart';

class LoadUserGetx extends GetxController {
  FirebaseUsecase usecase = injection<FirebaseUsecase>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onCheckUser();
    });
  }

  void onCheckUser() async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore
        .instance
        .collection('main-config')
        .doc('main')
        .get();

    Map<String, dynamic>? data = docSnapshot.data();
    await f.secureWrite(key: MainConfig.stringApiKey, value: data?['api-key']);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('main-user')
        .where('email', isEqualTo: f.boxRead(key: MainConfig.stringEmail))
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String id = querySnapshot.docs.first.id;
      Object? object = querySnapshot.docs.first.data();
      Map<String, dynamic> data = object as Map<String, dynamic>;

      String pin = data['pin'];
      String display = data['display'];

      await f.secureWrite(key: MainConfig.stringPIN, value: pin);
      await f.boxWrite(key: MainConfig.stringDisplay, value: display);
      await f.boxWrite(key: MainConfig.boolLogin, value: true);
      await f.secureWrite(key: MainConfig.stringID, value: id);

      Get.offAll(() => PinPage(), arguments: PINmethod.secure);
    } else {
      Get.offAll(() => RegisterPage());
    }
  }
}
