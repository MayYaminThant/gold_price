import 'package:flutter/material.dart';
import 'package:gold_price/controller/calculate_page_controller.dart';
import 'package:gold_price/model/calculating_gold.dart';
import 'package:gold_price/util/common_util.dart';
import 'package:gold_price/util/screen_util.dart';
import 'package:provider/provider.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({Key? key}) : super(key: key);

  @override
  _CalculatePageState createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
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
      _kyatTextController.text = calculatingGold.kyat! > 0
          ? calculatingGold.kyat!.toStringAsFixed(0)
          : "0";
      _paeTextController.text = calculatingGold.pae! > 0
          ? calculatingGold.pae!.toStringAsFixed(0)
          : "0";
      _ywayTextController.text = calculatingGold.yway! > 0
          ? calculatingGold.yway!.toStringAsFixed(0)
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
          _calculatedAmountWidget(),
          const SizedBox(height: 16),
          _calculatedEditor(),
        ],
      ),
    );
  }

  Widget _todayGoldPrice() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Container(
        width: ScreenSizeUtil.getScreenWidth(context),
        height: 80,
        decoration: _calculatedBoxDecoration(Colors.pink[50]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Consumer<CalulatePageController>(
              builder: (context, controller, widget) => TextField(
                keyboardType: TextInputType.number,
                cursorWidth: 2.5,
                cursorColor: Colors.pink.shade200,
                controller: _mainGoldPriceTextController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.pink.shade200, width: 3.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.pink.shade200, width: 3.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.pink.shade200, width: 3.0),
                  ),
                  hintText: 'Enter Today Gold Price',
                  hintStyle: TextStyle(
                      color: Colors.pink.shade100, letterSpacing: 1.5),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    return;
                  }
                  controller.todayGoldPrice = double.parse(value);
                  controller.calculatedAmount = double.parse(value);
                  controller.calculatingGold =
                      CalculatingGold(kyat: 1, pae: 0, yway: 0);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _calculatedAmountWidget() {
    return Container(
      width: ScreenSizeUtil.getScreenWidth(context),
      height: 120,
      decoration: _calculatedBoxDecoration(Colors.green.shade100),
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
            double ywayVal = paeVal - paeVal.truncateToDouble();

            controller.calculatingGold = CalculatingGold(
                kyat: kyatVal.truncateToDouble(),
                pae: paeVal.truncateToDouble(),
                yway: ywayVal);
          },
          ScreenSizeUtil.getScreenWidth(context) - 60,
          Colors.green.shade300,
          Colors.green.shade200,
          Colors.green.shade400,
        );
      }),
    );
  }

  Widget _calculatedEditor() {
    return Padding(
      padding: const EdgeInsets.only(right: 35.0),
      child: Container(
        padding: const EdgeInsets.only(left: 3.0),
        width: ScreenSizeUtil.getScreenWidth(context),
        height: ScreenSizeUtil.getScreenHeight(context) - 400,
        decoration: _calculatedBoxDecoration(Colors.lightBlue.shade100),
        child: Consumer<CalulatePageController>(
          builder: (_, controller, __) {
            if (controller.calculatingGold.kyat != null) {
              _kyatTextController.text =
                  controller.calculatingGold.kyat!.toStringAsFixed(0);
            }
            if (controller.calculatingGold.pae != null) {
              _paeTextController.text =
                  controller.calculatingGold.pae!.toStringAsFixed(0);
            }
            if (controller.calculatingGold.yway != null) {
              _ywayTextController.text =
                  controller.calculatingGold.yway!.toStringAsFixed(0);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _textFeildColumn(
                  'ကျပ်',
                  _kyatTextController,
                  controller,
                  (value) {
                    controller.calculatingGold.kyat = double.parse(value);
                  },
                  ScreenSizeUtil.getScreenWidth(context) - 90,
                  Colors.blue.shade300,
                  Colors.lightBlue.shade200,
                  Colors.blue.shade400,
                ),
                _textFeildColumn(
                  'ပဲ',
                  _paeTextController,
                  controller,
                  (value) {
                    controller.calculatingGold.pae = double.parse(value);
                  },
                  ScreenSizeUtil.getScreenWidth(context) - 90,
                  Colors.blue.shade400,
                  Colors.lightBlue.shade200,
                  Colors.blue.shade500,
                ),
                _textFeildColumn(
                  'ရွေး',
                  _ywayTextController,
                  controller,
                  (value) {
                    controller.calculatingGold.yway = double.parse(value);
                  },
                  ScreenSizeUtil.getScreenWidth(context) - 90,
                  Colors.blue.shade500,
                  Colors.lightBlue.shade200,
                  Colors.blue.shade600,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  BoxDecoration _calculatedBoxDecoration(color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5),
      boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(
            2.0,
            2.0,
          ),
          blurRadius: 8.0,
          spreadRadius: 1.5,
        ),
        BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
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
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 9.0, top: 3, bottom: 5),
          child: Text(
            title,
            style: TextStyle(color: color1, fontSize: 18, letterSpacing: 2),
          ),
        ),
        Row(
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.only(left: 8.0, right: 3.0),
              child: Center(
                child: TextFormField(
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    cursorWidth: 2.5,
                    cursorColor: color1,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color1, width: 3.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color1, width: 3.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: color1, width: 3.0),
                      ),
                      hintText: controller.calculateGoldType
                          ? 'Enter Gold Price'
                          : '0',
                      hintStyle: TextStyle(color: color2, letterSpacing: 1.5),
                    ),
                    onChanged: (value) => stringCallback(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter ' + title;
                      }

                      return null;
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: IconButton(
                  alignment: Alignment.centerLeft,
                  onPressed: () {},
                  icon: Icon(
                    Icons.mode_edit_outline_outlined,
                    size: 30,
                    color: color3,
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
