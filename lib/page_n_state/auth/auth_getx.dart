import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wings/fundamental/main_config.dart';
import 'package:wings/fundamental/main_function.dart';
import 'package:wings/page_n_state/load_user/load_user_page.dart';

class AuthGetx extends GetxController {
  void onGoogleLogin() async {
    f.onShowLoading();
    await GoogleSignIn().signIn().then((user) async {
      f.onEndLoading();

      if (user != null) {
        String email = user.email;
        String display = user.displayName ?? '';

        await f.boxWrite(key: MainConfig.stringEmail, value: email);
        await f.boxWrite(key: MainConfig.stringDisplay, value: display);

        Get.offAll(() => LoadUserPage());
      }
    });
  }
}
