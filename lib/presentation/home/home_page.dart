import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/core/main_image_path.dart';
import 'package:wings/core/main_widget.dart';
import 'package:wings/domain/entities/aset_entity.dart';
import 'package:wings/presentation/home/home_getx.dart';
import 'package:wings/presentation/transaction/transaction_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeGetx getx = Get.put(HomeGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
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
          child: RefreshIndicator(
            onRefresh: getx.onRefresh,
            backgroundColor: Colors.white,
            color: Colors.black,
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
                            widgetSaldo(),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: getx.onShowAset,
                                child: Obx(() => Icon(getx.showUserAset.value ? Icons.visibility : Icons.visibility_off, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                        // w.gap(height: 16),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: w.button(
                        //         onPressed: () {
                        //           f.onShowSnackbar(
                        //             title: 'asd',
                        //             message: 'message',
                        //           );
                        //         },
                        //         backgroundColor: Colors.white,
                        //         child: Row(
                        //           children: [
                        //             Icon(
                        //               Icons.file_download_outlined,
                        //               color: Colors.black,
                        //             ),
                        //             w.gap(width: 5),
                        //             w.text(
                        //               data: 'Deposit',
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 12,
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     w.gap(width: 16),
                        //     Expanded(
                        //       child: w.button(
                        //         onPressed: () {},
                        //         backgroundColor: Colors.white,
                        //         child: Row(
                        //           children: [
                        //             Icon(
                        //               Icons.attach_money,
                        //               color: Colors.black,
                        //             ),
                        //             w.gap(width: 5),
                        //             w.text(
                        //               data: 'Tarik',
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 12,
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    ),
                    child: Column(
                      children: [
                        // w.field(
                        //   controller: getx.controller,
                        //   label: w.text(data: 'Cari Aset', color: Colors.grey),
                        //   suffix: Icon(Icons.search, size: 16),
                        // ),
                        // w.gap(height: 16),
                        Obx(() => getx.isMarketDataLoading.value ? widgetListMarketLoading() : widgetListMarket()),
                        w.gap(height: 64),
                      ],
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

  Widget widgetSaldo() {
    return Obx(
      () => w.text(
        data: getx.showUserAset.value
            ? getx.isUserDataLoading.value
                  ? 'Memuat...'
                  : f.numFormat(getx.userAset.value, symbol: 'Rp')
            : 'Rp*****',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget widgetListMarketLoading() {
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

  Widget widgetListMarket() {
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: getx.listAsetMarket.length,
        itemBuilder: (context, index) {
          AsetEntity aset = getx.listAsetMarket[index];

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await Get.to(() => TransactionPage(), arguments: aset);
                getx.onRefresh();
              },
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      child: ClipOval(child: CachedNetworkImage(imageUrl: aset.image)),
                    ),
                    w.gap(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          w.text(data: aset.name, fontSize: 12, fontWeight: FontWeight.bold),
                          w.text(data: aset.id, fontSize: 10),
                        ],
                      ),
                    ),
                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          w.text(
                            data: f.numFormat(aset.currentPrice, symbol: 'Rp'),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          w.text(data: '${f.numFormat(aset.percent)}%', color: aset.percent >= 0 ? Colors.green : Colors.red, fontSize: 10),
                        ],
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
