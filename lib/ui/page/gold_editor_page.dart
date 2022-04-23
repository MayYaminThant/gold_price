import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gold_price/common/common_widget.dart';
import 'package:gold_price/controller/bottom_nav_controller.dart';
import 'package:gold_price/controller/gold_shop_controller.dart';
import 'package:gold_price/model/gold.dart';
import 'package:gold_price/util/common_util.dart';
import 'package:gold_price/util/screen_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../common/color_extension.dart';

class GoldEditorPage extends StatefulWidget {
  const GoldEditorPage({Key? key}) : super(key: key);

  @override
  _GoldEditorPageState createState() => _GoldEditorPageState();
}

class _GoldEditorPageState extends State<GoldEditorPage> {
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
  Gold? gold = null;

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
      _shopNameTextController.text = gold!.name;
      _sixteenPrcTextController.text = gold!.sixteenPrice;
      _fifteenPrcTextController.text = gold!.fifteenPrice;
      _phoneNoTextController.text = gold!.phoneNo;
      _facebookTextController.text = gold!.facebook;
      _websiteTextController.text = gold!.website;
      _createdDateTextController.text = gold!.createdDate;
      _modifiedDateTextController.text = gold!.modifiedDate;
    });
    return SafeArea(
        child: WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: gold != null && gold!.color != ""
            ? ColorExtension.fromHex(gold!.color)
            : Colors.white,
        // appBar: appBar(context),
        body: _mainBody(),
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
            if (!controller.isEditing) {
              if (controller.currentEditGold.name.isNotEmpty) {
                controller.currentEditGold = controller.newGold;
                Navigator.pop(context, "Backbutton data");
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
            (controller.currentEditGold.name.isNotEmpty ? 'Edit' : 'Add') +
                ' Gold Shop'),
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
          child:
              // Stack(
              //   children: [
              Consumer<GoldShopController>(
            builder: (_, controller, __) => Image.network(
              controller.currentEditGold.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => SizedBox(
                width: ScreenSizeUtil.getScreenWidth(context),
                child: Image.asset(
                  'assets/images/4.jpg',
                  color: Colors.grey.withOpacity(0.5),
                  colorBlendMode: BlendMode.srcOver,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: SpeedDial(
            backgroundColor: Colors.transparent,
            overlayColor: Colors.transparent,
            overlayOpacity: 0.2,
            elevation: 0,
            childrenButtonSize: const Size(50, 50),
            child: const Icon(Icons.menu, size: 27),
            direction: SpeedDialDirection.down,
            children: <SpeedDialChild>[
              SpeedDialChild(
                  child: const Icon(
                    Icons.check,
                    color: Colors.red,
                    size: 33,
                  ),
                  onTap: () {
                    showWarningDialog();
                  }),
              SpeedDialChild(
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 33,
                  ),
                  onTap: () {
                    setState(() {});
                  }),
              SpeedDialChild(
                child: const Icon(
                  Icons.add_a_photo,
                  color: Colors.blueGrey,
                  size: 33,
                ),
                onTap: () {
                  _showImagePickerDialog(context);
                },
              ),
            ],
          ),
        )
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
        // CustomScrollView(
        //   scrollDirection: Axis.horizontal,
        //   slivers: [_getColorSliverList(context)],
        // ),
        SliverToBoxAdapter(
            child: MaterialColorPicker(
          iconSelected: Icons.api,
          circleSize: 39,
          selectedColor: gold != null && gold!.color != ""
              ? ColorExtension.fromHex(gold!.color)
              : Colors.white,
          onColorChange: (changedColor) {
            // gold!.color = changedColor.value.toRadixString(16);
          },
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Sixteen Gold Price',
          _sixteenPrcTextController,
          false,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Fifteen Gold Price',
          _fifteenPrcTextController,
          false,
        )),
        SliverToBoxAdapter(
            child: textFormField(
          'Phone No.',
          _phoneNoTextController,
          false,
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
    String title,
    TextEditingController controller,
    bool isDate,
  ) {
    return Container(
      width: ScreenSizeUtil.getScreenWidth(context) - 16,
      // height: 60,
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(8),
      child: isDate
          ? getDateTextField(title, controller)
          : getTextField(title, controller),
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
  ) {
    return Consumer<GoldShopController>(
      builder: (_, goldcontroller, __) => TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 0, 101, 234),
              width: 2.5,
            ),
          ),
        ),
        onChanged: (value) {
          goldcontroller.isEditing = true;
        },
      ),
    );
  }

  showWarningDialog() {
    return warningDialog(
      context,
      'Are you sure you want to change data!',
      'Update',
      () {
        GoldShopController(1).updateGoldData(
          context,
          gold!.id,
          {
            'name': _shopNameTextController.text,
            'sixteen_price': _sixteenPrcTextController.text,
            'fifteen_price': _fifteenPrcTextController.text,
            'phoneNo': _phoneNoTextController.text,
            'website': _websiteTextController.text,
            'facebook': _facebookTextController.text,
            'created_date': Timestamp.fromDate(DateTime.parse(
                _createdDateTextController.text)), //millisecondsSinceEpoch
            'modified_date': Timestamp.fromDate(
                DateTime.parse(_modifiedDateTextController.text)),
          },
        );
        Navigator.of(context).pop();
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
    controller.uploadPic(context, source, controller);
  }

  // SliverList _getColorSliverList(BuildContext context) {
  //   return SliverList(
  //     delegate: SliverChildBuilderDelegate(
  //       (BuildContext context, int index) {
  //         return buildRow(colors[index]);
  //       },
  //       childCount: colors.length,
  //     ),
  //   );
  // }

  buildRow(String color) {
    return Container(
      decoration: BoxDecoration(
        color: ColorExtension.fromHex(color),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
