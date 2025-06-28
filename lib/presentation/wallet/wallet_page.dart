import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/core/main_image_path.dart';
import 'package:wings/core/main_widget.dart';
import 'package:wings/data/models/data_model.dart';
import 'package:wings/domain/entities/aset_entity.dart';
import 'package:wings/presentation/transaction/transaction_page.dart';
import 'package:wings/presentation/wallet/wallet_getx.dart';

class WalletPage extends StatelessWidget {
  WalletPage({super.key});

  final WalletGetx getx = Get.put(WalletGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset(ImagePath.icon_dark, scale: 16),
            w.text(data: 'Wings', color: Colors.white, fontWeight: FontWeight.bold),
          ],
        ),
      ),
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      w.text(data: 'Nilai Total Aset', fontSize: 14, color: Colors.white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widgetAset(),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: getx.onShowAset,
                              child: Obx(() => Icon(getx.showUserAset.value ? Icons.visibility : Icons.visibility_off, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  ),
                  child: Obx(() => getx.isLoading.value ? widgetListAsetLoading() : widgetListAset()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetAset() {
    return Obx(
      () => w.text(
        data: getx.showUserAset.value
            ? getx.isLoading.value
                  ? 'Memuat...'
                  : f.numFormat(getx.userAset.value, symbol: 'Rp')
            : 'Rp*****',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget widgetListAsetLoading() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          CircularProgressIndicator(color: Colors.black, backgroundColor: Colors.transparent),
          w.gap(height: 16),
          w.text(data: 'Mengambil Data', fontSize: 12, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  Widget widgetListAset() {
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: getx.realListUserAset.length,
        itemBuilder: (context, index) {
          DataModel data = getx.realListUserAset[index];
          AsetEntity asetData = AsetEntity(id: data.id, symbol: '', name: data.name, image: data.image, currentPrice: 0, percent: 0);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await Get.to(() => TransactionPage(), arguments: asetData);
                getx.onGetUserData();
              },
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      child: ClipOval(child: CachedNetworkImage(imageUrl: data.image)),
                    ),
                    w.gap(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        w.text(data: data.name, fontSize: 12, fontWeight: FontWeight.bold),
                        w.text(data: data.id, fontSize: 10),
                      ],
                    ),
                    Spacer(),
                    IntrinsicWidth(
                      child: w.text(
                        data: f.numFormat(data.aset, symbol: 'Rp'),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(color: Colors.black);
        },
      ),
    );
  }
}
