import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wings/fundamental/main_function.dart';
import 'package:wings/fundamental/main_widget.dart';
import 'package:wings/page_n_state/transaction/transaction_getx.dart';

class TransactionPage extends StatelessWidget {
  TransactionPage({super.key});

  final TransactionGetx getx = Get.put(TransactionGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: getx.globalKey,
          child: Obx(
            () => getx.isDone.value
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 32,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: getx.aset.image,
                                ),
                              ),
                            ),
                            w.gap(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                w.text(
                                  data: getx.aset.name,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                w.text(data: getx.aset.id, fontSize: 10),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                w.text(
                                  data: 'Nilai ${getx.aset.name} Anda:',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                Obx(
                                  () => w.text(
                                    data: f.numFormat(
                                      getx.myCoin.value,
                                      symbol: 'Rp',
                                    ),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        w.gap(height: 16),
                        w.field(
                          controller: getx.controller,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          label: w.text(
                            data: 'Nilai Transaksi',
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          onChanged: getx.onChanged,
                          validator: getx.onValidatorTransaction,
                        ),
                        w.gap(height: 5),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(
                            () => w.text(
                              data: 'Saldo ${f.numFormat(getx.rupiah.value)}',
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        w.gap(height: 16),
                        Row(
                          children: [
                            w.text(
                              data: 'Harga ${getx.aset.name} saat ini :',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            Spacer(),
                            Obx(
                              () => w.text(
                                data: 'Update harga (${getx.resetIn.value})',
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            w.gap(width: 5),
                            w.text(
                              data: f.numFormat(
                                getx.currentPrice.value,
                                symbol: 'Rp',
                              ),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        w.gap(height: 16),
                        Row(
                          children: [
                            w.text(
                              data: 'Biaya transaksi (1.25%) :',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            Spacer(),
                            Obx(
                              () => w.text(
                                data: f.numFormat(getx.fee.value, symbol: 'Rp'),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        w.gap(height: 16),
                        Row(
                          children: [
                            w.text(
                              data: 'Aset yang anda terima :',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            Spacer(),
                            Obx(
                              () => w.text(
                                data: f.numFormat(
                                  getx.finalPrice.value,
                                  symbol: 'Rp',
                                ),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: w.button(
                  onPressed: getx.onBeli,
                  backgroundColor: Colors.green,
                  borderColor: Colors.black,
                  child: w.text(
                    data: 'Beli',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              w.gap(width: 16),
              Expanded(
                child: w.button(
                  onPressed: getx.onJual,
                  backgroundColor: Colors.red,
                  borderColor: Colors.black,
                  child: w.text(
                    data: 'jual',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
