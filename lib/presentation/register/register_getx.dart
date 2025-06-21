import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/core/main_widget.dart';
import 'package:wings/data/models/user_model.dart';
import 'package:wings/domain/usecases/firebase_usecase.dart';
import 'package:wings/injection_container.dart';
import 'package:wings/presentation/dashboard/dashboard_page.dart';
import 'package:wings/presentation/pin/pin_page.dart';

class RegisterGetx extends GetxController {
  FirebaseUsecase usecase = injection<FirebaseUsecase>();

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  RxBool snk = false.obs;

  RxString snkValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await onGetSNK();
      controller.text = getDisplay();
    });
  }

  void onChanged(bool? value) {
    snk.value = value ?? false;
  }

  void onShowSNK() {
    f.onShowBottomSheet(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            w.text(data: snkValue.value),
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
                child: w.text(data: 'Saya menyetujui Syarat dan Ketentuan yang berlaku', fontSize: 12),
              ),
            ),
          ],
        ),
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
    String email = f.boxRead(key: MainConfig.stringEmail);
    UserModel userData = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      data: '[]',
      display: controller.text,
      email: email,
      pin: pin,
      rupiah: '0',
    );

    await usecase.saveUserData(model: userData).then((value) {
      value.fold(
        (left) {
          f.onShowSnackbar(title: 'Terjadi masalah', message: 'Gagal menyimpan data pengguna');
        },
        (right) async {
          await f.secureWrite(key: MainConfig.stringPIN, value: pin);
          await f.boxWrite(key: MainConfig.stringDisplay, value: controller.text);
          await f.boxWrite(key: MainConfig.boolLogin, value: true);
        },
      );
    });

    f.onEndLoading();
    Get.offAll(() => DashboardPage());
  }

  String? displayValidator(String? value) {
    if (value == null || value.isEmpty) return 'Display masih kosong!';
    if (value.length < 5) return 'Panjang minimal 5 huruf/angka';
    if (value.contains(' ')) return 'Tidak boleh ada spasi!';
    return null;
  }

  Future<void> onGetSNK() async {
    f.onShowLoading();
    await usecase.getApiKey(field: 'snk').then((value) {
      f.onEndLoading();

      value.fold(
        (left) {
          f.onShowSnackbar(title: 'Terjadi Masalah', message: 'Gagal mendapatkan data syarat & ketentuan');
        },
        (right) {
          snkValue.value = right;
        },
      );
    });
  }
}
