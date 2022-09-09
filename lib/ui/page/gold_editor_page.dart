import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../common/common_widget.dart';
import '../../controller/bottom_nav_controller.dart';
import '../../controller/gold_shop_controller.dart';
import '../../model/gold.dart';
import '../../util/common_util.dart';
import '../../util/image_util.dart';
import '../../util/screen_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../common/color_extension.dart';

class GoldEditorPage extends StatefulWidget {
  const GoldEditorPage({Key? key}) : super(key: key);

  @override
  GoldEditorPageState createState() => GoldEditorPageState();
}

class GoldEditorPageState extends State<GoldEditorPage> {
  final TextEditingController _shopNameTextController = TextEditingController();
  final TextEditingController _sixteenPrcTextController =
      TextEditingController();
  final TextEditingController _fifteenPrcTextController =
      TextEditingController();
  final TextEditingController _phoneNoTextController = TextEditingController();
  final TextEditingController _facebookTextController = TextEditingController();
  final TextEditingController _websiteTextController = TextEditingController();
  final TextEditingController _createdDateTextController =
      TextEditingController();
  final TextEditingController _modifiedDateTextController =
      TextEditingController();
  final TextEditingController _pswTextController = TextEditingController();
  Gold? gold;

  @override
  void dispose() {
    _shopNameTextController.dispose();
    _sixteenPrcTextController.dispose();
    _fifteenPrcTextController.dispose();
    _phoneNoTextController.dispose();
    _facebookTextController.dispose();
    _websiteTextController.dispose();
    _createdDateTextController.dispose();
    _modifiedDateTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CommonUtil.doInFuture(() {
      gold = context.read<GoldShopController>().currentEditGold;
      _shopNameTextController.text = gold?.name ?? '';
      _sixteenPrcTextController.text = gold?.sixteenPrice ?? '0';
      _fifteenPrcTextController.text = gold?.fifteenPrice ?? '0';
      _phoneNoTextController.text = gold?.phoneNo ?? '';
      _facebookTextController.text = gold?.facebook ?? '';
      _websiteTextController.text = gold?.website ?? '';
      _createdDateTextController.text = gold?.createdDate ?? '';
      _modifiedDateTextController.text = gold?.modifiedDate ?? '';
      _pswTextController.text = gold?.goldShopPassword ?? '';
    });
    return SafeArea(
        child: WillPopScope(
      onWillPop: () => Future.value(false),
      child: Consumer<GoldShopController>(
        builder: (_, controller, __) => Scaffold(
          // backgroundColor: controller.currentEditGold.color != ""
          //     ? ColorExtension.fromHex(gold?.color ?? '#ffffff')
          //     : Colors.white,

          body: _mainBody(),
        ),
      ),
    ));
  }

  Widget _getAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.grey,
      leading: Consumer<GoldShopController>(
        builder: (_, controller, __) => IconButton(
          onPressed: () {
            controller.pickedImageFile = null;
            if (!controller.isEditing) {
              if (controller.currentEditGold.name.isNotEmpty) {
                controller.goldForDetail = controller.currentEditGold;
                controller.currentEditGold = controller.newGold;
                Navigator.pop(context);
              } else {
                controller.currentEditGold = controller.newGold;
                context.read<BottomNavController>().selectedIndex = 0;
              }
            } else {
              controller.isEditing = false;
              setState(() {});
            }
          },
          icon: controller.isEditing
              ? const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: Colors.white,
                ),
        ),
      ),
      title: Consumer<GoldShopController>(
        builder: (_, controller, __) => Text(
            '${controller.currentEditGold.name.isNotEmpty ? 'Edit' : 'Add'} Gold Shop'),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
          StretchMode.zoomBackground,
        ],
        background: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [
                Colors.black12.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
          child: Consumer<GoldShopController>(
            builder: (_, controller, __) => controller.pickedImageFile != null
                ? Image.file(
                    controller.pickedImageFile!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => getErrorImage(context),
                  )
                : Image.network(
                    controller.currentEditGold.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => getErrorImage(context),
                  ),
          ),
        ),
      ),
      actions: [
        Consumer<GoldShopController>(
          builder: (_, controller, __) => controller.isEditing
              ? IconButton(
                  onPressed: () {
                    _confirmationInsertOrUpdateDataWarningDialog();
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 33,
                  ))
              : const SizedBox(),
        ),
        IconButton(
            onPressed: () {
              _showImagePickerDialog(context);
            },
            icon: const Icon(
              Icons.add_a_photo,
              color: Colors.white,
              size: 33,
            )),
      ],
    );
  }

  Widget _mainBody() {
    return CustomScrollView(
      slivers: <Widget>[
        _getAppBar(),
        const SliverToBoxAdapter(
          child: SizedBox(),
        ),
        SliverToBoxAdapter(
            child: textFormField(
          'Shop Name',
          _shopNameTextController,
          false,
        )),
        SliverToBoxAdapter(
            child: getPasswordTextField(
          'Password',
          _pswTextController,
        )),
        SliverToBoxAdapter(
          child: Consumer<GoldShopController>(
            builder: (_, goldCon, __) => Container(
              height: 70,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: colors.length,
                itemBuilder: (buildContext, position) =>
                    colorBuilderContainer(goldCon, position),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
            child: textFormField(
          'Sixteen Gold Price',
          _sixteenPrcTextController,
          false,
          inputType: TextInputType.number,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Fifteen Gold Price',
          _fifteenPrcTextController,
          false,
          inputType: TextInputType.number,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Phone No.',
          _phoneNoTextController,
          false,
          inputType: TextInputType.phone,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Facebook',
          _facebookTextController,
          false,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Website',
          _websiteTextController,
          false,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Created Date',
          _createdDateTextController,
          true,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Modified Date',
          _modifiedDateTextController,
          true,
        )),
      ],
    );
  }

  Widget textFormField(
      String title, TextEditingController controller, bool isDate,
      {TextInputType inputType = TextInputType.text}) {
    return Container(
      width: ScreenSizeUtil.getScreenWidth(context) - 16,
      // height: 60,
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(8),
      child: isDate
          ? getDateTextField(title, controller)
          : getTextField(title, controller, inputType),
    );
  }

  getDateTextField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.withAlpha(80),
            width: 0,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      onTap: () async {
        var date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100));
        controller.text = date.toString().substring(0, 10);
      },
    );
  }

  getTextField(
    String title,
    TextEditingController controller,
    TextInputType inputType,
  ) {
    return Consumer<GoldShopController>(
      builder: (_, goldcontroller, __) => TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: title,
          border: _borderTextFormField(),
          focusedBorder: _focusedBorderTextFormField(),
        ),
        onChanged: (value) {
          goldcontroller.isEditing = true;
        },
      ),
    );
  }

  getPasswordTextField(String title, TextEditingController controller) {
    return Container(
      width: ScreenSizeUtil.getScreenWidth(context) - 16,
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(8),
      child: Consumer<GoldShopController>(
        builder: (_, goldcontroller, __) => TextFormField(
          controller: controller,
          maxLength: 8,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            labelText: title,
            border: _borderTextFormField(),
            focusedBorder: _focusedBorderTextFormField(),
          ),
          onChanged: (value) {
            goldcontroller.isEditing = true;
          },
        ),
      ),
    );
  }

  OutlineInputBorder _focusedBorderTextFormField() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 0, 101, 234),
        width: 2.5,
      ),
    );
  }

  OutlineInputBorder _borderTextFormField() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    );
  }

  _confirmationInsertOrUpdateDataWarningDialog() {
    if (gold != null &&
        (gold!.sixteenPriceList.isEmpty ||
            double.parse(_sixteenPrcTextController.text) !=
                double.parse(gold!.sixteenPriceList.values.last))) {
      if (gold!.sixteenPriceList.length == 10) {
        gold!.sixteenPriceList.remove(gold!.sixteenPriceList.entries.first.key);
      }
      gold!.sixteenPriceList.putIfAbsent(
          getDateWithCustomFormat(
              DateTime.now(), dateFormatDayMonthYearHourMinSecond),
          () => _sixteenPrcTextController.text);
    }
    if (gold != null &&
        (gold!.fifteenPriceList.isEmpty ||
            double.parse(_fifteenPrcTextController.text) !=
                double.parse(gold!.fifteenPriceList.values.last))) {
      if (gold!.fifteenPriceList.length == 10) {
        gold!.fifteenPriceList.remove(gold!.fifteenPriceList.entries.first.key);
      }
      gold!.fifteenPriceList.putIfAbsent(
          getDateWithCustomFormat(
              DateTime.now(), dateFormatDayMonthYearHourMinSecond),
          () => _fifteenPrcTextController.text);
    }
    bool isInsertedData = false;
    if (gold == null || gold!.id.isEmpty || gold!.id == '0') {
      isInsertedData = true;
    }
    if (_pswTextController.text.isEmpty) {
      showSimpleSnackBar(context, "Password should not be empty!", Colors.red);
      return;
    }

    return warningDialog(
      context,
      'Are you sure you want to ${isInsertedData ? 'add' : 'change'} data!',
      isInsertedData ? 'Add' : 'Update',
      () async {
        Navigator.of(context).pop(); // to close confirmation updating dialog

        GoldShopController goldShopController =
            context.read<GoldShopController>();
        String imageDownloadUrl = "";
        if (goldShopController.pickedImageFile != null) {
          imageDownloadUrl = await goldShopController.uploadPic(context);
        }
        goldShopController.fetchInsertOrUpdateGold(
          gold,
          {
            'name': _shopNameTextController.text,
            'sixteen_price': _sixteenPrcTextController.text,
            'fifteen_price': _fifteenPrcTextController.text,
            'phoneNo': _phoneNoTextController.text,
            'website': _websiteTextController.text,
            'facebook': _facebookTextController.text,
            'created_date': Timestamp.fromDate(DateTime.parse(
                _createdDateTextController.text.isEmpty
                    ? DateTime.now().toString()
                    : _createdDateTextController
                        .text)), //millisecondsSinceEpoch
            'modified_date': Timestamp.fromDate(DateTime.parse(
                _modifiedDateTextController.text.isEmpty
                    ? DateTime.now().toString()
                    : _modifiedDateTextController.text)),
            'sixteen_price_list': gold?.sixteenPriceList ?? <String, String>{},
            'fifteen_price_list': gold?.fifteenPriceList ?? <String, String>{},
            'color_hex':
                (gold?.color.isNotEmpty == true ? gold?.color : colors[0]),
            'imageUrl': gold?.imageUrl ?? '',
            'gold_shop_password': _pswTextController.text,
          },
          goldShopController.pickedImageFile != null,
          imageDownloadUrl,
          successCallback: () {
            showSimpleSnackBar(
              context,
              '${isInsertedData ? 'Insert' : 'Updated'} Successful',
              Colors.green.shade200,
            );
            goldShopController.isEditing = false;
          },
          failureCallback: (dynamic error) {
            showSimpleSnackBar(
              context,
              '${isInsertedData ? 'Insert' : 'Updated'} Failed: $error',
              Colors.green.shade200,
            );
          },
        );
      },
      () {
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _showImagePickerDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  Consumer<GoldShopController>(
                    builder: (_, controller, __) => ListTile(
                      onTap: () {
                        _openGalleryOrCamera(
                            context, ImageSource.gallery, controller);
                      },
                      title: const Text("Gallery"),
                      leading: const Icon(
                        Icons.account_box,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  Consumer<GoldShopController>(
                    builder: (_, controller, __) => ListTile(
                      onTap: () {
                        _openGalleryOrCamera(
                            context, ImageSource.camera, controller);
                      },
                      title: const Text("Camera"),
                      leading: const Icon(
                        Icons.camera,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _openGalleryOrCamera(
    BuildContext context,
    ImageSource source,
    GoldShopController controller,
  ) async {
    controller.pickImage(context, source, controller);
    Navigator.pop(context);
  }

  buildRow(String color) {
    return Container(
      decoration: BoxDecoration(
        color: ColorExtension.fromHex(color),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}

Widget colorBuilderContainer(GoldShopController controller, int index) {
  return InkWell(
    onTap: () {
      if (colors[index].isNotEmpty) {
        controller.currentEditGold.color = colors[index];
        controller.isEditing = true;
        controller.refreshData();
      }
    },
    child: Container(
        height: 40,
        width: 55,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: ColorExtension.fromHex(colors[index]),
            // border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(40)),
        child: ((controller.currentEditGold.color.isEmpty && index == 0) ||
                (controller.currentEditGold.color != "" &&
                    controller.currentEditGold.color == colors[index]))
            ? const Icon(Icons.check)
            : const SizedBox()),
  );
}
