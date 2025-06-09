import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/utils.dart';
import 'package:wings/fundamental/main_image_path.dart';
import 'package:wings/fundamental/main_widget.dart';
import 'package:wings/page_n_state/auth/auth_getx.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final AuthGetx getx = Get.put(AuthGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            w.text(
              data: 'Wings Excahnge',
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            w.text(data: 'transaksi mudah & cepat', fontSize: 12),
            w.gap(height: 16),
            w.button(
              onPressed: getx.onGoogleLogin,
              backgroundColor: Colors.white,
              borderColor: Colors.black,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  w.text(
                    data: 'Masuk Dengan Google',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  w.gap(width: 5),
                  Image.asset(ImagePath.google, scale: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
