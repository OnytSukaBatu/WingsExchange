import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/presentation/load_user/load_user_getx.dart';

class LoadUserPage extends StatelessWidget {
  LoadUserPage({super.key});

  final LoadUserGetx getx = Get.put(LoadUserGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(color: Colors.black, backgroundColor: Colors.transparent),
      ),
    );
  }
}
