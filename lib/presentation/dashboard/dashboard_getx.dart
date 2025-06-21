import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/presentation/home/home_getx.dart';
import 'package:wings/presentation/home/home_page.dart';
import 'package:wings/presentation/setting/setting_page.dart';
import 'package:wings/presentation/wallet/wallet_getx.dart';
import 'package:wings/presentation/wallet/wallet_page.dart';

class DashboardGetx extends GetxController {
  PageController controller = PageController();
  List<Widget> page = <Widget>[HomePage(), SettingPage(), WalletPage()];
  RxInt index = 0.obs;

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
