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
      if (context.read<CalulatePageController>().todayGoldPrice != 0) {
        _mainGoldPriceTextController.text = context
            .read<CalulatePageController>()
            .todayGoldPrice
            .toStringAsFixed(0);
      }
      if (context.read<CalulatePageController>().calculatedAmount != 0) {
        _calculatedGoldPriceTextController.text = context
            .read<CalulatePageController>()
            .calculatedAmount
            .toStringAsFixed(0);
      }
      CalculatingGold calculatingGold =
          context.read<CalulatePageController>().calculatingGold;
      _kyatTextController.text = (calculatingGold.kyat ?? 0) > 0
          ? (calculatingGold.kyat ?? 0).toStringAsFixed(0)
          : "";
      _paeTextController.text = (calculatingGold.pae ?? 0) > 0
          ? (calculatingGold.kyat ?? 0).toStringAsFixed(0)
          : "";
      _ywayTextController.text = (calculatingGold.yway ?? 0) > 0
          ? (calculatingGold.kyat ?? 0).toStringAsFixed(0)
          : "";
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
          _calculatedAmountWidget(),
          const SizedBox(height: 16),
          _calculatedKyatEditor(),
          const SizedBox(height: 10),
          _calculatedPaeEditor(),
          const SizedBox(height: 10),
          _calculatedYwayEditor(),
        ],
      ),
    );
  }

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
          _calculatedBoxDecoration(Colors.pink[50], Colors.pink.shade200),
      child: Consumer<CalulatePageController>(builder: (_, controller, __) {
        if (controller.calculatedAmount > 0) {
          _calculatedGoldPriceTextController.text =
              controller.calculatedAmount.toStringAsFixed(0);
        }
        return _textFeildColumn(
          'ယနေ့ရွှေဈေး',
          _mainGoldPriceTextController,
          controller,
          (value) {
            if (value.isEmpty) {
              _calculatedGoldPriceTextController.clear();
              _kyatTextController.clear();
              _paeTextController.clear();
              _ywayTextController.clear();
              return;
            }
            controller.todayGoldPrice = double.parse(value);
            controller.calculatedAmount = double.parse(value);
            controller.calculatingGold =
                CalculatingGold(kyat: 1, pae: 0, yway: 0);
          },
          () {
            _mainGoldPriceTextController.clear();
            controller.todayGoldPrice = 0;
            controller.calculatedAmount = 0;
            controller.calculatingGold =
                CalculatingGold(kyat: 0, pae: 0, yway: 0);

            _calculatedGoldPriceTextController.clear();
            _kyatTextController.clear();
            _paeTextController.clear();
            _ywayTextController.clear();
          },
          ScreenSizeUtil.getScreenWidth(context) - 110,
          Colors.pink.shade800,
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
      decoration:
          _calculatedBoxDecoration(Colors.green.shade50, Colors.green.shade200),
      child: Consumer<CalulatePageController>(builder: (_, controller, __) {
        if (controller.calculatedAmount > 0) {
          _calculatedGoldPriceTextController.text =
              controller.calculatedAmount.toStringAsFixed(0);
        }
        return _textFeildColumn(
          'ကျသင့်(သို့)တတ်နိုင်သော ပမာဏ',
          _calculatedGoldPriceTextController,
          controller,
          (value) {
            if (controller.todayGoldPrice <= 0 || value.isEmpty) {
              _kyatTextController.clear();
              _paeTextController.clear();
              _ywayTextController.clear();
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
          () {
            controller.calculatedAmount = 0;
            _calculatedGoldPriceTextController.clear();
          },
          ScreenSizeUtil.getScreenWidth(context) - 110,
          Colors.green.shade800,
          Colors.green.shade200,
          Colors.green.shade400,
          Colors.green.shade700,
        );
      }),
    );
  }

  Widget _calculatedKyatEditor() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
        top: 5,
        bottom: 5,
      ),
      child: Container(
        width: ScreenSizeUtil.getScreenWidth(context),
        height: (ScreenSizeUtil.getScreenHeight(context) / 3) - 150,
        decoration: _calculatedBoxDecoration(
            Colors.lightBlue.shade50, Colors.lightBlue.shade200),
        child: Consumer<CalulatePageController>(
          builder: (_, controller, __) {
            if (controller.calculatingGold.kyat != null) {
              _kyatTextController.text =
                  (controller.calculatingGold.kyat ?? 0).toStringAsFixed(0);
            }
            return _textFeildColumn(
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
                _kyatTextController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _kyatTextController.text.length));
                _calculatingAmount(controller, result);
              },
              () {
                controller.calculatingGold.kyat = 0;
                _kyatTextController.clear();
              },
              ScreenSizeUtil.getScreenWidth(context) - 110,
              Colors.blue.shade800,
              Colors.blue.shade200,
              Colors.blue.shade400,
              Colors.blue.shade700,
            );
          },
        ),
      ),
    );
  }

  Widget _calculatedPaeEditor() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
        top: 5,
        bottom: 5,
      ),
      child: Container(
        width: ScreenSizeUtil.getScreenWidth(context),
        height: (ScreenSizeUtil.getScreenHeight(context) / 3) - 150,
        decoration: _calculatedBoxDecoration(
            Colors.amber.shade50, Colors.amber.shade200),
        child: Consumer<CalulatePageController>(
          builder: (_, controller, __) {
            if (controller.calculatingGold.pae != null) {
              _paeTextController.text =
                  (controller.calculatingGold.pae ?? 0).toStringAsFixed(0);
            }
            return _textFeildColumn(
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
              () {
                controller.calculatingGold.pae = 0;
                _paeTextController.clear();
              },
              ScreenSizeUtil.getScreenWidth(context) - 110,
              Colors.amber.shade800,
              Colors.amber.shade200,
              Colors.amber.shade500,
              Colors.amber.shade700,
            );
          },
        ),
      ),
    );
  }

  Widget _calculatedYwayEditor() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
        top: 5,
        bottom: 5,
      ),
      child: Container(
        width: ScreenSizeUtil.getScreenWidth(context),
        height: (ScreenSizeUtil.getScreenHeight(context) / 3) - 150,
        decoration: _calculatedBoxDecoration(
            Colors.purple.shade50, Colors.purple.shade200),
        child: Consumer<CalulatePageController>(
          builder: (_, controller, __) {
            if (controller.calculatingGold.yway != null) {
              _ywayTextController.text =
                  (controller.calculatingGold.yway ?? 0).toStringAsFixed(0);
            }
            return _textFeildColumn(
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
              () {
                controller.calculatingGold.yway = 0;
                _ywayTextController.clear();
              },
              ScreenSizeUtil.getScreenWidth(context) - 110,
              Colors.purple.shade800,
              Colors.purple.shade200,
              Colors.purple.shade600,
              Colors.purple.shade700,
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
      border: Border.all(color: boxShadowColor),
      borderRadius: BorderRadius.circular(6),
      // boxShadow: [
      //   BoxShadow(
      //     color: boxShadowColor,
      //     offset: const Offset(2, 3),
      //     blurRadius: 10,
      //     spreadRadius: 0.05,
      //   ),
      //   const BoxShadow(
      //     color: Colors.white,
      //     offset: Offset(-4, -4),
      //     blurRadius: 10,
      //     spreadRadius: 1,
      //   ),
      // ],
    );
  }

  Column _textFeildColumn(
    String title,
    TextEditingController textEditingController,
    CalulatePageController controller,
    Function(String) stringCallback,
    VoidCallback clearCallback,
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
          padding: const EdgeInsets.only(left: 22.0, top: 3, bottom: 5),
          child: Text(
            title,
            style: TextStyle(color: color1, fontSize: 18, letterSpacing: 1),
          ),
        ),
        DottedLine(
          dashColor: color4,
          lineThickness: 0.4,
          dashLength: 4.8,
        ),
        Container(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    cursorWidth: 2.5,
                    cursorColor: color1,
                    controller: textEditingController,
                    style: const TextStyle(letterSpacing: 4, fontSize: 20),
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 20),
                      hintText: controller.calculateGoldType
                          ? 'Enter Gold Price'
                          : '0',
                      hintStyle: TextStyle(
                          color: color2, letterSpacing: 4, fontSize: 20),
                    ),
                    onFieldSubmitted: (value) => stringCallback(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter $title';
                      }
                      return null;
                    }),
              ),
              if (textEditingController.text.isNotEmpty &&
                  textEditingController.text != "0")
                IconButton(
                  onPressed: () {
                    clearCallback();
                  },
                  icon: Icon(
                    Icons.cancel_rounded,
                    size: 32,
                    color: color1,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
