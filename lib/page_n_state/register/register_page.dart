import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wings/fundamental/main_widget.dart';
import 'package:wings/page_n_state/register/register_getx.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final RegisterGetx getx = Get.put(RegisterGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: getx.globalKey,
        child: Center(
          child: Container(
            width: 280,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                w.text(
                  data: 'Sebelum Melanjutkan Buat Username Terlebih Dahulu',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                w.gap(height: 16),
                w.field(
                  controller: getx.controller,
                  label: w.text(
                    data: 'Masukan Username',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLength: 16,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                  validator: getx.displayValidator,
                ),
                w.gap(height: 5),
                Row(
                  children: [
                    Obx(
                      () => w.checkBox(
                        value: getx.snk.value,
                        onChanged: getx.onChanged,
                        activeColor: Colors.black,
                        checkColors: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: getx.onShowSNK,
                        child: w.text(
                          data: 'saya menyetujui syarat dan ketentuan',
                          fontSize: 12,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
                w.gap(height: 5),
                w.button(
                  onPressed: getx.onSimpan,
                  backgroundColor: Colors.white,
                  borderColor: Colors.black,
                  child: w.text(data: 'Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
