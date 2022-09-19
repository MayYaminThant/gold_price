import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/color_extension.dart';
import '../../common/common_widget.dart';
import '../../controller/bottom_nav_controller.dart';
import '../../controller/gold_shop_controller.dart';
import '../../model/gold.dart';
import '../../util/common_util.dart';
import 'gold_detail.dart';

class GoldDetail2 extends StatefulWidget {
  const GoldDetail2({super.key});

  @override
  State<GoldDetail2> createState() => _GoldDetail2State();
}

class _GoldDetail2State extends State<GoldDetail2> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController pswController = TextEditingController();
  final GlobalKey<FormState> _keyDialogForm = GlobalKey<FormState>();
  late Gold gold;
  @override
  void dispose() {
    titleController.dispose();
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
              size: 30,
            ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gold.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 6),
            if (gold.phoneNo.isNotEmpty)
              _detailContainerUI(gold.phoneNo,
                  color: Colors.white54,
                  action: ServiceAction.phone,
                  textFontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic),
            const SizedBox(height: 6),
            if (gold.facebook.isNotEmpty)
              _detailContainerUI(gold.facebook,
                  color: Colors.white54,
                  action: ServiceAction.facebook,
                  textFontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic),
            const SizedBox(height: 6),
            if (gold.website.isNotEmpty)
              _detailContainerUI(gold.website,
                  color: Colors.white54,
                  action: ServiceAction.website,
                  textFontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic),
          ],
        ),
      ),
    );
  }

  Consumer<GoldShopController> _deleteShopUIAndAction(Gold gold) {
    return Consumer<GoldShopController>(
      builder: (_, controller, __) => IconButton(
          onPressed: () {
            _showPasswordConfirmationDialog(submittedCallback: () {
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
            });
          },
          icon: const Icon(
            Icons.delete_forever_rounded,
            size: 30,
          )),
    );
  }

  Future _showPasswordConfirmationDialog(
      {required VoidCallback submittedCallback}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Form(
            key: _keyDialogForm,
            child: Column(
              children: <Widget>[
                const Text(
                  'Input your gold shop password',
                  style: TextStyle(fontSize: 17.5),
                ),
                TextFormField(
                  autofocus: true,
                  controller: pswController,
                  decoration: const InputDecoration(
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    // errorStyle: TextStyle(color: Colors.blue),
                  ),
                  maxLength: 8,
                  textAlign: TextAlign.center,
                  onSaved: (val) {
                    if (val != null && val.isNotEmpty) {
                      titleController.text = val;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Password';
                    }

                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (String text) {
                    submittedCallback.call();
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                submittedCallback.call();
              },
              child: const Text('Confirm'),
            ),
            ElevatedButton(
                onPressed: () {
                  pswController.text = "";
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
          ],
        );
      },
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
}
