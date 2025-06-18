import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_widget.dart';
import 'package:wings/presentation/pin/pin_getx.dart';

class PinPage extends StatelessWidget {
  PinPage({super.key});

  final PinGetx getx = Get.put(PinGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => w.text(
                          data: getx.message.value,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      w.gap(height: 16),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (index) {
                            bool filled = index < getx.value.value.length;

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: filled ? Colors.black : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    numButton(input: '1'),
                    numButton(input: '2'),
                    numButton(input: '3'),
                  ],
                ),
                w.gap(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    numButton(input: '4'),
                    numButton(input: '5'),
                    numButton(input: '6'),
                  ],
                ),
                w.gap(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    numButton(input: '7'),
                    numButton(input: '8'),
                    numButton(input: '9'),
                  ],
                ),
                w.gap(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 64),
                    numButton(input: '0'),
                    delButton(),
                  ],
                ),
                w.gap(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget numButton({required String input}) {
    return SizedBox(
      height: 64,
      width: 64,
      child: w.button(
        onPressed: () {
          getx.onTap(input);
        },
        borderRadius: BorderRadius.circular(32),
        backgroundColor: Colors.white,
        borderColor: Colors.black,
        child: w.text(
          data: '$input',
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget delButton() {
    return SizedBox(
      height: 64,
      width: 64,
      child: w.button(
        onPressed: getx.onBack,
        onLongPress: getx.onHold,
        borderRadius: BorderRadius.circular(32),
        backgroundColor: Colors.white,
        borderColor: Colors.black,
        child: Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }
}
