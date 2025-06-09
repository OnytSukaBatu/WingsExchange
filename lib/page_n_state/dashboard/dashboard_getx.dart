import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/page_n_state/home/home_getx.dart';
import 'package:wings/page_n_state/home/home_page.dart';
import 'package:wings/page_n_state/setting/setting_page.dart';
import 'package:wings/page_n_state/wallet/wallet_getx.dart';
import 'package:wings/page_n_state/wallet/wallet_page.dart';

class DashboardGetx extends GetxController {
  RxInt index = 0.obs;
  PageController controller = PageController();
  List<Widget> page = <Widget>[HomePage(), SettingPage(), WalletPage()];

  @override
  void onClose() {
    super.onClose();
    controller.dispose();
  }

  void onTap(int i) {
    index.value = i;
    controller.jumpToPage(i);
  }

  void onPageChanged(int i) {
    index.value = i;
    if (index.value == 0) Get.find<HomeGetx>().onRefresh();
    if (index.value == 2) Get.find<WalletGetx>().onGetUserData();
  }
}
