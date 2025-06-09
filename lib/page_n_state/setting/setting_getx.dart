import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wings/fundamental/main_config.dart';
import 'package:wings/fundamental/main_function.dart';
import 'package:wings/page_n_state/auth/auth_page.dart';

class SettingGetx extends GetxController {
  List<List> menuProfil = <List>[
    ['Username', Icons.person, null, f.boxRead(key: MainConfig.stringDisplay)],
    ['Email', Icons.email, null, f.boxRead(key: MainConfig.stringEmail)],
  ];

  late RxList<RxList> menuUmum;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      menuUmum = [
        ['Versi Aplikasi', Icons.android, null, 'versi 1.0.0'].obs,
        ['Logout', Icons.logout, onLogout, null].obs,
      ].obs;
    });
  }

  void onLogout() async {
    f.onShowLoading();
    await GoogleSignIn().signOut();
    await f.boxClear();
    f.onEndLoading();

    Get.offAll(() => AuthPage());
  }
}
