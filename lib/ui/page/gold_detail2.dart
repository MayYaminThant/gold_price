import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gold_price/util/intl_util.dart';
import 'package:provider/provider.dart';

import '../../common/color_extension.dart';
import '../../common/common_widget.dart';
import '../../controller/bottom_nav_controller.dart';
import '../../controller/gold_shop_controller.dart';
import '../../model/gold.dart';
import '../../util/common_util.dart';
import '../../util/image_util.dart';
import 'gold_detail.dart';
import 'main_page.dart';

class GoldDetail2 extends StatefulWidget {
  const GoldDetail2({super.key});

  @override
  State<GoldDetail2> createState() => _GoldDetail2State();
}

class _GoldDetail2State extends State<GoldDetail2> {
  final TextEditingController pswController = TextEditingController();
  final GlobalKey<FormState> _keyDialogForm = GlobalKey<FormState>();
  late Gold gold;
  @override
  void dispose() {
    pswController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    gold = context.read<GoldShopController>().goldForDetail;
    CommonUtil.doInFuture(() {
      gold = context.read<GoldShopController>().goldForDetail;
      setState(() {});
    });
    return Scaffold(
      backgroundColor: ColorExtension.fromHex('#DE8573'),
      appBar: _appBar(),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showConfirmationDialog(
            context,
            _keyDialogForm,
            'Input your gold shop password',
            'Enter Your Password',
            submittedCallback: (text) {
              pswController.text = text;
              goToGoldEditorPage(gold);
            },
            cancelCallback: () {
              pswController.text = "";
              Navigator.pop(context);
            },
          );
        },
        backgroundColor: const Color.fromRGBO(160, 50, 50, 1),
        child: const Icon(Icons.edit),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: ColorExtension.fromHex('#DE8573'),
      leading: Consumer<BottomNavController>(
        builder: (_, bController, __) => Consumer<GoldShopController>(
          builder: (_, controller, __) => IconButton(
            onPressed: () {
              bController.selectedIndex = 0;
              controller.currentEditGold = controller.newGold;
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
      ),
      title: Center(
        child: Text(
          gold.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
      actions: [
        _deleteShopUIAndAction(gold),
      ],
    );
  }

  Widget _body() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 12, top: 30, bottom: 10),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailContainerUI(
                'အခေါက်ရွှေဈေး ( ${IntlUtils.formatPrice(gold.sixteenPrice)} )',
                color: Colors.white,
                action: ServiceAction.none,
                textFontSize: 17,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal),
            const SizedBox(height: 4),
            _detailContainerUI(
                '15 ပဲရည် ( ${IntlUtils.formatPrice(gold.fifteenPrice)} ) ',
                color: Colors.white,
                action: ServiceAction.none,
                textFontSize: 17,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal),
            const SizedBox(height: 30),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                gold.imageUrl,
                fit: BoxFit.fitWidth,
                width: double.infinity,
                errorBuilder: (_, __, ___) => getErrorImage(context),
              ),
            ),
            const SizedBox(height: 30),
            if (gold.phoneNo.isNotEmpty)
              _detailContainerUI(gold.phoneNo,
                  color: Colors.white54,
                  action: ServiceAction.phone,
                  textFontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic),
            const SizedBox(height: 8),
            if (gold.facebook.isNotEmpty)
              _detailContainerUI(gold.facebook,
                  color: Colors.white54,
                  action: ServiceAction.facebook,
                  textFontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic),
            const SizedBox(height: 8),
            if (gold.website.isNotEmpty)
              _detailContainerUI(gold.website,
                  color: Colors.white54,
                  action: ServiceAction.website,
                  textFontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic),
            const SizedBox(height: 8),
            _detailContainerUI('Update by ${gold.modifiedDate}',
                color: Colors.white54,
                action: ServiceAction.none,
                textFontSize: 16,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal),
            const SizedBox(height: 27),
          ],
        ),
      ),
    );
  }

  Consumer<GoldShopController> _deleteShopUIAndAction(Gold gold) {
    return Consumer<GoldShopController>(
      builder: (_, controller, __) => IconButton(
          onPressed: () {
            showConfirmationDialog(
              context,
              _keyDialogForm,
              'Input your gold shop password',
              'Enter Your Password',
              submittedCallback: (text) {
                pswController.text = text;
                controller.deleteGoldData(
                  gold.id,
                  successCallback: () {
                    Navigator.pop(context);
                    showSimpleSnackBar(
                      context,
                      'Delete Successful',
                      Colors.green.shade200,
                    );
                  },
                  failureCallback: (dynamic error) {
                    Navigator.pop(context);
                    showSimpleSnackBar(
                      context,
                      'Delete Failed: $error',
                      Colors.green.shade200,
                    );
                  },
                );
              },
              cancelCallback: () {
                pswController.text = "";
                Navigator.pop(context);
              },
            );
          },
          icon: const Icon(
            Icons.delete_forever_rounded,
          )),
    );
  }

  Widget _detailContainerUI(
    String value, {
    Color? color,
    ServiceAction action = ServiceAction.none,
    double? textFontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) {
    return InkWell(
      onTap: () async {
        switch (action) {
          case ServiceAction.phone:
            makePhoneCall(context, value);
            break;

          case ServiceAction.facebook:
            String fbProtocolUrl;
            if (Platform.isIOS) {
              fbProtocolUrl = 'fb://profile/page_id';
            } else {
              fbProtocolUrl = 'fb://page/page_id';
            }
            launchInBrowser(context, fbProtocolUrl);
            break;

          case ServiceAction.website:
            launchInBrowser(context, value);
            break;
          default:
        }
      },
      child: Text(
        value,
        style: TextStyle(
            fontSize: textFontSize,
            color: color,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            decoration: (action == ServiceAction.none
                ? TextDecoration.none
                : TextDecoration.underline)),
      ),
    );
  }

  void goToGoldEditorPage(Gold gold) {
    if (_keyDialogForm.currentState != null &&
        _keyDialogForm.currentState!.validate()) {
      _keyDialogForm.currentState!.save();

      GoldShopController.checkGoldPassword(
        gold.id,
        pswController.text,
        () {
          pswController.text = "";
          Navigator.pop(context);
          context.read<BottomNavController>().selectedIndex = 1;
          context.read<GoldShopController>().currentEditGold = gold;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const MainPage();
              },
            ),
          );
        },
        () {
          var psw = pswController.text;
          pswController.text = "";
          showSimpleSnackBar(
              context, "Your password($psw) is invalid!", Colors.red);
          Navigator.pop(context);
        },
      );
    }
  }
}
