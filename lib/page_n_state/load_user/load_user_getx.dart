import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/fundamental/main_config.dart';
import 'package:wings/fundamental/main_function.dart';
import 'package:wings/page_n_state/pin/pin_page.dart';
import 'package:wings/page_n_state/register/register_page.dart';

class LoadUserGetx extends GetxController {
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
      String transaction = data['data'];
      String rupiah = data['rupiah'];

      await f.secureWrite(key: MainConfig.stringPIN, value: pin);
      await f.boxWrite(key: MainConfig.stringDisplay, value: display);
      await f.boxWrite(key: MainConfig.stringTransaction, value: transaction);
      await f.boxWrite(key: MainConfig.stringRupiah, value: rupiah);
      await f.boxWrite(key: MainConfig.boolLogin, value: true);
      await f.secureWrite(key: MainConfig.stringID, value: id);

      Get.offAll(() => PinPage(), arguments: PINmethod.secure);
    } else {
      Get.offAll(() => RegisterPage());
    }
  }
}
