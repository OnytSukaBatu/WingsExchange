import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:wings/core/main_widget.dart';

class MainFunction with FuncGetStorage, FuncSecureStorage {
  Future onShowBottomSheet({
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    bool? isDismissible,
    BorderRadiusGeometry? borderRadius,
    double? height,
  }) async {
    padding ??= EdgeInsets.all(16);
    backgroundColor ??= Colors.white;
    isDismissible ??= false;
    borderRadius ??= BorderRadius.circular(16);

    return await Get.bottomSheet(
      SafeArea(
        child: Container(height: height ?? Get.height, width: Get.width, padding: padding, child: child),
      ),
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
    );
  }

  Future onShowDialog({required Widget child, Color? backgroundColor, BorderRadiusGeometry? borderRadius}) async {
    backgroundColor ??= Colors.white;
    borderRadius ??= BorderRadius.circular(16);

    return await Get.dialog(
      Dialog(
        backgroundColor: backgroundColor,
        child: child,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      barrierDismissible: false,
    );
  }

  void onShowLoading() {
    onShowDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          w.gap(height: 32),
          w.text(data: 'Tunggu Sebentar'),
          w.gap(height: 16),
          SizedBox(
            width: 160,
            child: LinearProgressIndicator(backgroundColor: Colors.grey, color: Colors.black),
          ),
          w.gap(height: 32),
        ],
      ),
    );
  }

  void onEndLoading() {
    Get.back();
  }

  String numFormat(num number, {String? symbol}) {
    NumberFormat formatter = NumberFormat.currency(locale: 'id_ID', symbol: symbol ?? '', decimalDigits: 2);
    return formatter.format(number);
  }

  void onShowSnackbar({
    required String title,
    required String message,
    Duration? animationDuration,
    Color? backgroundColor,
    Color? borderColor,
    double? borderRadius,
    double? borderWidth,
    Duration? duration,
    EdgeInsets? padding,
  }) {
    animationDuration ??= Duration(milliseconds: 500);
    backgroundColor ??= Colors.white;
    borderColor ??= Colors.black;
    borderRadius ??= 5;
    borderWidth ??= 1;
    duration ??= Duration(seconds: 3);

    Get.snackbar(
      '',
      '',
      animationDuration: animationDuration,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      duration: duration,
      messageText: w.text(data: message, fontSize: 10, textAlign: TextAlign.left),
      margin: EdgeInsets.all(8),
      titleText: w.text(data: title, fontSize: 12, fontWeight: FontWeight.bold, textAlign: TextAlign.left),
      padding: padding,
    );
  }

  double doubleD(double price) {
    return double.parse(price.toStringAsFixed(2));
  }

  double getPrice({required double oldPrice, required double totalAset, required double newPrice}) {
    double diff = ((newPrice - oldPrice) / oldPrice) * 100;
    double percent = 1 + (diff / 100);
    return totalAset * percent;
  }

  void onShowWarn(String title) {
    f.onShowDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          w.gap(height: 16),
          w.text(data: title),
          w.gap(height: 5),
          w.button(
            onPressed: Get.back,
            backgroundColor: Colors.white,
            borderColor: Colors.black,
            child: w.text(data: 'Mengerti'),
          ),
          w.gap(height: 16),
        ],
      ),
    );
  }
}

MainFunction get f => MainFunction();

mixin FuncGetStorage {
  GetStorage box = GetStorage();

  Future<void> boxWrite({required String key, required dynamic value}) async {
    await box.write(key, value);
  }

  dynamic boxRead({required String key, dynamic dv}) {
    return box.read(key) ?? dv ?? null;
  }

  Future<void> boxDelete({required String key}) async {
    await box.remove(key);
  }

  Future<void> boxClear() async {
    await box.erase();
  }
}

mixin FuncSecureStorage {
  FlutterSecureStorage storage = FlutterSecureStorage(aOptions: const AndroidOptions(encryptedSharedPreferences: true));

  Future<void> secureWrite({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  Future<String> secureRead({required String key, String? dv}) async {
    return await storage.read(key: key) ?? dv ?? '';
  }

  Future<void> secureDelete({required String key}) async {
    await storage.delete(key: key);
  }

  Future<void> secureClear() async {
    await storage.deleteAll();
  }
}
