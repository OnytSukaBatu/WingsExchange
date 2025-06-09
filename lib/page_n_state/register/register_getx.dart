import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/fundamental/main_config.dart';
import 'package:wings/fundamental/main_function.dart';
import 'package:wings/fundamental/main_widget.dart';
import 'package:wings/page_n_state/dashboard/dashboard_page.dart';
import 'package:wings/page_n_state/pin/pin_page.dart';

class RegisterGetx extends GetxController {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  RxBool snk = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.text = getDisplay();
    });
  }

  void onChanged(bool? value) {
    snk.value = value ?? false;
  }

  void onShowSNK() {
    f.onShowBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          w.text(data: 'Syarat dan Ketentuan'),
          w.gap(height: 16),
          SizedBox(
            width: double.infinity,
            child: w.button(
              onPressed: () {
                Get.back();
                snk.value = true;
              },
              backgroundColor: Colors.white,
              borderColor: Colors.black,
              child: w.text(
                data: 'Saya menyetujui Syarat dan Ketentuan yang berlaku',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getDisplay() {
    String display = f.boxRead(key: MainConfig.stringDisplay);
    String noSpaces = display.replaceAll(RegExp(r'\s+'), '');
    return noSpaces.length <= 16 ? noSpaces : noSpaces.substring(0, 16);
  }

  void onSimpan() async {
    if (!globalKey.currentState!.validate()) return;
    if (!snk.value) return;

    String? pin = await Get.to(() => PinPage(), arguments: PINmethod.create);
    if (pin == null) {
      f.onShowDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            w.text(data: 'Gagal mendapatkan PIN silahkan coba lagi'),
            w.gap(height: 5),
            w.button(
              onPressed: Get.back,
              backgroundColor: Colors.white,
              borderColor: Colors.black,
              child: w.text(data: 'Mengerti'),
            ),
          ],
        ),
      );
      return;
    }

    f.onShowLoading();
    DocumentReference doc = await FirebaseFirestore.instance
        .collection('main-user')
        .add({
          'email': f.boxRead(key: MainConfig.stringEmail),
          'display': controller.text,
          'data': '[]',
          'pin': pin,
          'rupiah': '0',
        });
    await f.secureWrite(key: MainConfig.stringPIN, value: pin);
    await f.boxWrite(key: MainConfig.stringDisplay, value: controller.text);
    await f.boxWrite(key: MainConfig.stringTransaction, value: '[]');
    await f.boxWrite(key: MainConfig.stringRupiah, value: '0');
    await f.boxWrite(key: MainConfig.boolLogin, value: true);
    await f.secureWrite(key: MainConfig.stringID, value: doc.id);
    f.onEndLoading();

    Get.offAll(() => DashboardPage());
  }

  String? displayValidator(String? value) {
    if (value == null || value.isEmpty) return 'Display masih kosong!';
    if (value.length < 5) return 'Panjang minimal 5 huruf/angka';
    if (value.contains(' ')) return 'Tidak boleh ada spasi!';
    return null;
  }
}
