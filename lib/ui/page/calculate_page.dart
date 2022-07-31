import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:gold_price/controller/calculate_page_controller.dart';
import 'package:gold_price/model/calculating_gold.dart';
import 'package:gold_price/util/common_util.dart';
import 'package:gold_price/util/screen_util.dart';
import 'package:provider/provider.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({Key? key}) : super(key: key);

  @override
  CalculatePageState createState() => CalculatePageState();
}

class CalculatePageState extends State<CalculatePage> {
  final TextEditingController _mainGoldPriceTextController =
      TextEditingController();
  final TextEditingController _calculatedGoldPriceTextController =
      TextEditingController();
  final TextEditingController _kyatTextController = TextEditingController();
  final TextEditingController _paeTextController = TextEditingController();
  final TextEditingController _ywayTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CommonUtil.doInFuture(() {
      _mainGoldPriceTextController.text = context
          .read<CalulatePageController>()
          .todayGoldPrice
          .toStringAsFixed(0);
      _calculatedGoldPriceTextController.text = context
          .read<CalulatePageController>()
          .calculatedAmount
          .toStringAsFixed(0);
      CalculatingGold calculatingGold =
          context.read<CalulatePageController>().calculatingGold;
      _kyatTextController.text = (calculatingGold.kyat ?? 0) > 0
          ? (calculatingGold.kyat ?? 0).toStringAsFixed(0)
          : "0";
      _paeTextController.text = (calculatingGold.pae ?? 0) > 0
          ? (calculatingGold.kyat ?? 0).toStringAsFixed(0)
          : "0";
      _ywayTextController.text = (calculatingGold.yway ?? 0) > 0
          ? (calculatingGold.kyat ?? 0).toStringAsFixed(0)
          : "0";
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _mainPage(),
      ),
    );
  }

  Widget _mainPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          _todayGoldPrice(),
          const SizedBox(height: 16),
          // const Padding(
          //   padding: EdgeInsets.only(left: 9.0, top: 3, bottom: 5),
          //   child: Text(
          //     "Calculated Amount",
          //     textAlign: TextAlign.start,
          //     style: TextStyle(fontSize: 18, letterSpacing: 1.2),
          //   ),
          // ),
          _calculatedAmountWidget(),
          const SizedBox(height: 16),
          _calculatedEditor(),
        ],
      ),
    );
  }

  // Widget _todayGoldPrice1() {
  //   return Padding(
  //     // padding: const EdgeInsets.only(left: 30),
  //     padding: const EdgeInsets.only(
  //       left: 30,
  //       right: 30,
  //       top: 5,
  //       bottom: 5,
  //     ),
  //     child: Container(
  //       width: ScreenSizeUtil.getScreenWidth(context),
  //       height: 60,
  //       decoration:
  //           _calculatedBoxDecoration(Colors.pink[50], Colors.pink.shade300),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Center(
  //           child: Consumer<CalulatePageController>(
  //             builder: (context, controller, widget) => TextField(
  //               keyboardType: TextInputType.number,
  //               cursorWidth: 2.5,
  //               cursorColor: Colors.pink.shade200,
  //               controller: _mainGoldPriceTextController,
  //               decoration: InputDecoration(
  //                 focusedBorder: InputBorder.none,
  //                 enabledBorder: InputBorder.none,
  //                 border: InputBorder.none,
  //                 hintText: 'Enter Today Gold Price',
  //                 hintStyle: TextStyle(
  //                     color: Colors.pink.shade100, letterSpacing: 1.5),
  //               ),
  //               onChanged: (value) {
  //                 if (value.isEmpty) {
  //                   return;
  //                 }
  //                 controller.todayGoldPrice = double.parse(value);
  //                 controller.calculatedAmount = double.parse(value);
  //                 controller.calculatingGold =
  //                     CalculatingGold(kyat: 1, pae: 0, yway: 0);
  //               },
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Container _todayGoldPrice() {
    return Container(
      width: ScreenSizeUtil.getScreenWidth(context),
      height: 110,
      margin: const EdgeInsets.only(
        left: 25,
        right: 25,
        top: 5,
        bottom: 0,
      ),
      decoration:
          _calculatedBoxDecoration(Colors.pink[50], Colors.pink.shade300),
      child: Consumer<CalulatePageController>(builder: (_, controller, __) {
        if (controller.calculatedAmount > 0) {
          _calculatedGoldPriceTextController.text =
              controller.calculatedAmount.toStringAsFixed(0);
        }
        return _textFeildColumn(
          'Enter Today Gold Price',
          _mainGoldPriceTextController,
          controller,
          (value) {
            if (value.isEmpty) {
              return;
            }
            controller.todayGoldPrice = double.parse(value);
            controller.calculatedAmount = double.parse(value);
            controller.calculatingGold =
                CalculatingGold(kyat: 1, pae: 0, yway: 0);
          },
          ScreenSizeUtil.getScreenWidth(context) - 110,
          Colors.pink.shade200,
          Colors.pink.shade100,
          Colors.pink.shade300,
          Colors.pink.shade500,
        );
      }),
    );
  }

  Container _calculatedAmountWidget() {
    return Container(
      width: ScreenSizeUtil.getScreenWidth(context),
      height: 110,
      margin: const EdgeInsets.only(
        left: 25,
        right: 25,
        top: 4,
        bottom: 0,
      ),
      decoration: _calculatedBoxDecoration(
          Colors.green.shade100, Colors.green.shade500),
      child: Consumer<CalulatePageController>(builder: (_, controller, __) {
        if (controller.calculatedAmount > 0) {
          _calculatedGoldPriceTextController.text =
              controller.calculatedAmount.toStringAsFixed(0);
        }
        return _textFeildColumn(
          'Calculated Amount',
          _calculatedGoldPriceTextController,
          controller,
          (value) {
            if (controller.todayGoldPrice <= 0 || value.isEmpty) {
              return;
            }
            double result = double.parse(value);
            controller.calculatedAmount = result;
            _calculatedGoldPriceTextController.selection =
                TextSelection.fromPosition(TextPosition(
                    offset: _calculatedGoldPriceTextController.text.length));
            double kyatVal = result / controller.todayGoldPrice;
            double paeVal = (kyatVal - kyatVal.truncateToDouble()) * 16;
            double ywayVal = (paeVal - paeVal.truncateToDouble()) * 8;

            controller.calculatingGold = CalculatingGold(
                kyat: kyatVal.truncateToDouble(),
                pae: paeVal.truncateToDouble(),
                yway: ywayVal);
          },
          ScreenSizeUtil.getScreenWidth(context) - 110,
          Colors.green.shade300,
          Colors.green.shade200,
          Colors.green.shade400,
          Colors.green.shade700,
        );
      }),
    );
  }

  Widget _calculatedEditor() {
    return Padding(
      // padding: const EdgeInsets.only(right: 35.0),
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
        top: 5,
        bottom: 5,
      ),
      child: Container(
        // padding: const EdgeInsets.only(left: 3.0),
        width: ScreenSizeUtil.getScreenWidth(context),
        // height: ScreenSizeUtil.getScreenHeight(context) - 400,
        height: ScreenSizeUtil.getScreenHeight(context) - 410,
        decoration: _calculatedBoxDecoration(
            Colors.lightBlue.shade100, Colors.lightBlue.shade600),
        child: Consumer<CalulatePageController>(
          builder: (_, controller, __) {
            if (controller.calculatingGold.kyat != null) {
              _kyatTextController.text =
                  (controller.calculatingGold.kyat ?? 0).toStringAsFixed(0);
            }
            if (controller.calculatingGold.pae != null) {
              _paeTextController.text =
                  (controller.calculatingGold.pae ?? 0).toStringAsFixed(0);
            }
            if (controller.calculatingGold.yway != null) {
              _ywayTextController.text =
                  (controller.calculatingGold.yway ?? 0).toStringAsFixed(0);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  // color: Colors.white,
                  // padding: const EdgeInsets.only(left: 3.0),
                  // width: ScreenSizeUtil.getScreenWidth(context),
                  // height: ScreenSizeUtil.getScreenHeight(context) - 400,
                  // decoration: _calculatedBoxDecoration(
                  //     Colors.lightBlue.shade100, Colors.lightBlue.shade200),
                  child: _textFeildColumn(
                    'ကျပ်',
                    _kyatTextController,
                    controller,
                    (value) {
                      if (controller.todayGoldPrice <= 0) {
                        return;
                      }
                      if (value.isEmpty) {
                        value = "0";
                      }
                      controller.calculatingGold.kyat = double.parse(value);

                      double result = double.parse(value);
                      _kyatTextController.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: _kyatTextController.text.length));
                      _calculatingAmount(controller, result);
                    },
                    ScreenSizeUtil.getScreenWidth(context) - 110,
                    Colors.blue.shade300,
                    Colors.lightBlue.shade700,
                    Colors.blue.shade400,
                    Colors.blue.shade700,
                  ),
                ),
                const DottedLine(
                  dashColor: Color.fromARGB(255, 70, 133, 243),
                ),
                _textFeildColumn(
                  'ပဲ',
                  _paeTextController,
                  controller,
                  (value) {
                    if (controller.todayGoldPrice <= 0) {
                      return;
                    }
                    if (value.isEmpty) {
                      value = "0";
                    }
                    controller.calculatingGold.pae = double.parse(value);

                    double result = double.parse(value);
                    _paeTextController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _paeTextController.text.length));
                    _calculatingAmount(controller, result);
                  },
                  ScreenSizeUtil.getScreenWidth(context) - 110,
                  Colors.blue.shade400,
                  Colors.lightBlue.shade700,
                  Colors.blue.shade500,
                  Colors.blue.shade700,
                ),
                const DottedLine(
                  dashColor: Color.fromARGB(255, 70, 133, 243),
                ),
                _textFeildColumn(
                  'ရွေး',
                  _ywayTextController,
                  controller,
                  (value) {
                    if (controller.todayGoldPrice <= 0) {
                      return;
                    }
                    if (value.isEmpty) {
                      value = "0";
                    }
                    controller.calculatingGold.yway = double.parse(value);

                    double result = double.parse(value);
                    _ywayTextController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _ywayTextController.text.length));
                    _calculatingAmount(controller, result);
                  },
                  ScreenSizeUtil.getScreenWidth(context) - 110,
                  Colors.blue.shade500,
                  Colors.lightBlue.shade700,
                  Colors.blue.shade600,
                  Colors.blue.shade700,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _calculatingAmount(CalulatePageController controller, double result) {
    double kyatVal =
        (controller.calculatingGold.kyat ?? 0) * controller.todayGoldPrice;
    double paeVal = (controller.todayGoldPrice / 16) *
        (controller.calculatingGold.pae ?? 0);
    double ywayVal = (controller.todayGoldPrice / 16 / 8) *
        (controller.calculatingGold.yway ?? 0);

    controller.calculatedAmount = kyatVal + paeVal + ywayVal;
  }

  BoxDecoration _calculatedBoxDecoration(color, boxShadowColor) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(6),
      boxShadow: [
        BoxShadow(
          color: boxShadowColor,
          offset: const Offset(2, 3),
          blurRadius: 10,
          spreadRadius: 0.05,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(-4, -4),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    );
  }

  Column _textFeildColumn(
    String title,
    TextEditingController textEditingController,
    CalulatePageController controller,
    Function(String) stringCallback,
    double width,
    Color color1,
    Color color2,
    Color color3,
    Color color4,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 9.0, top: 3, bottom: 5),
          child: Text(
            title,
            style: TextStyle(color: color1, fontSize: 18, letterSpacing: 1.2),
          ),
        ),
        SizedBox(
          height: 1,
          child: Container(
            color: color4,
            margin: const EdgeInsets.only(left: 3.5, right: 3.5),
          ),
        ),
        Container(
          // width: width,
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Center(
            child: TextFormField(
                textAlign: TextAlign.end,
                keyboardType: TextInputType.number,
                cursorWidth: 2.5,
                cursorColor: color1,
                controller: textEditingController,
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText:
                      controller.calculateGoldType ? 'Enter Gold Price' : '0',
                  hintStyle: TextStyle(color: color2, letterSpacing: 1.5),
                ),
                onFieldSubmitted: (value) => stringCallback(value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter $title';
                  }
                  return null;
                }),
          ),
        ),
      ],
    );
  }
}
