import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:wings/core/main_widget.dart';
import 'package:wings/presentation/setting/setting_getx.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final SettingGetx getx = Get.put(SettingGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              w.text(
                data: 'Profil Pengguna',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              w.gap(height: 5),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    List data = getx.menuProfil[index];
                    return widgetMenu(
                      data: data[0],
                      icon: data[1],
                      onTap: data[2],
                      value: data[3],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(color: Colors.black, height: 1);
                  },
                  itemCount: getx.menuProfil.length,
                ),
              ),
              w.gap(height: 16),
              w.text(
                data: 'Menu Umum',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              w.gap(height: 5),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black),
                ),
                child: Obx(
                  () => ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      List data = getx.menuUmum[index];
                      return widgetMenu(
                        data: data[0],
                        icon: data[1],
                        onTap: data[2],
                        value: data[3],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(color: Colors.black, height: 1);
                    },
                    itemCount: getx.menuUmum.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget widgetMenu({
  required String data,
  required IconData? icon,
  Function()? onTap,
  String? value,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
        child: Row(
          children: [
            w.text(data: data, fontSize: 12, fontWeight: FontWeight.bold),
            Spacer(),
            Icon(icon, size: 16),
            Visibility(
              visible: value != null,
              child: Row(
                children: [
                  w.gap(width: 5),
                  w.text(
                    data: value ?? '',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
