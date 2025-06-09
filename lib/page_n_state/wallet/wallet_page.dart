import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/fundamental/main_function.dart';
import 'package:wings/fundamental/main_image_path.dart';
import 'package:wings/fundamental/main_model/data_model.dart';
import 'package:wings/fundamental/main_widget.dart';
import 'package:wings/page_n_state/wallet/wallet_getx.dart';

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
            w.text(
              data: 'Wings',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: getx.onGetUserData,
            backgroundColor: Colors.white,
            color: Colors.black,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        w.text(
                          data: 'Nilai Total Aset',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => w.text(
                                data: getx.showAset.value
                                    ? f.numFormat(
                                        getx.asetValue.value,
                                        symbol: 'Rp',
                                      )
                                    : 'Rp*****',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: getx.onShowAset,
                                child: Obx(
                                  () => Icon(
                                    getx.showAset.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Obx(
                      () => ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: getx.realData.length,
                        itemBuilder: (context, index) {
                          DataModel data = getx.realData[index];
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 32,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: data.image,
                                    ),
                                  ),
                                ),
                                w.gap(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    w.text(
                                      data: data.name,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    w.text(data: data.id, fontSize: 10),
                                  ],
                                ),
                                Spacer(),
                                IntrinsicWidth(
                                  child: w.text(
                                    data: f.numFormat(data.aset),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(color: Colors.black);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
