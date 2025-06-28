import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_widget.dart';
import 'package:wings/presentation/reset/reset_getx.dart';

class ResetPage extends StatelessWidget {
  ResetPage({super.key});

  final ResetGetx getx = Get.put(ResetGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: getx.globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: w.text(data: 'Masukan OTP yang dikirim ke ${getx.email}, OTP bersifat 1 kali penggunaan'),
                ),
                w.gap(height: 16),
                w.field(
                  controller: getx.controller,
                  label: w.text(data: 'OTP', fontSize: 12),
                  maxLength: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: getx.validator,
                ),
                w.gap(height: 5),
                Obx(() => w.text(data: 'kadaluarsa dalam ${getx.format(getx.remainingTime.value)}', fontSize: 12, color: Colors.grey)),
                w.gap(height: 5),
                Obx(
                  () => Visibility(
                    visible: getx.remainingTime.value <= 0,
                    child: InkWell(
                      onTap: getx.init,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        child: w.text(data: 'Kirim ulang OTP', fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                w.gap(height: 16),
                Obx(
                  () => w.button(
                    onPressed: getx.onValidate,
                    backgroundColor: Colors.black,
                    child: w.text(data: 'Konfirmasi', color: Colors.white),
                    enabled: getx.remainingTime.value > 0,
                  ),
                ),
                w.gap(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
