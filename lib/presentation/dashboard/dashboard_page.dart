import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wings/presentation/dashboard/dashboard_getx.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final DashboardGetx getx = Get.put(DashboardGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          children: getx.page,
          controller: getx.controller,
          onPageChanged: getx.onPageChanged,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(
        () => Padding(
          padding: const EdgeInsets.all(8),
          child: PhysicalModel(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            elevation: 8,
            child: BottomNavigationBar(
              currentIndex: getx.index.value,
              onTap: getx.onTap,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Pengaturan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.wallet),
                  label: 'Dompet',
                ),
              ],
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
              selectedIconTheme: IconThemeData(color: Colors.white, size: 20),
              unselectedIconTheme: IconThemeData(color: Colors.grey, size: 16),
            ),
          ),
        ),
      ),
    );
  }
}
