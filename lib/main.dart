import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wings/firebase_options.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/core/main_image_path.dart';
import 'package:wings/core/main_widget.dart';
import 'package:wings/injection_container.dart';
import 'package:wings/presentation/auth/auth_page.dart';
import 'package:wings/presentation/pin/pin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  await initInjection();
  f.onEmailInit();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0x80000000),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: GenesisPage(),
      debugShowCheckedModeBanner: false,
      // theme: f.lightTheme,
      // darkTheme: f.darkTheme,
      // themeMode: ThemeMode.light,
    );
  }
}

class GenesisPage extends StatelessWidget {
  GenesisPage({super.key});

  final GenesisGetx getx = Get.put(GenesisGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImagePath.icon_light, scale: 2.5),
            w.gap(height: 5),
            w.text(data: 'Mohon Tunggu...'),
            w.gap(height: 16),
            SizedBox(
              width: 160,
              child: LinearProgressIndicator(backgroundColor: Colors.grey, color: Colors.black),
            ),
            w.gap(height: 160),
          ],
        ),
      ),
    );
  }
}

class GenesisGetx extends GetxController {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback(doInit);
  }

  void doInit(Duration _) async {
    // await f.onThemeInit(Get.context!);
    bool alreadyLogin = f.boxRead(key: MainConfig.boolLogin, dv: false);
    if (!alreadyLogin) return Get.offAll(() => AuthPage());
    Get.offAll(() => PinPage(), arguments: PINmethod.secure);
  }
}
