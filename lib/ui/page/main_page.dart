import 'dart:async';

import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:gold_price/common/common_widget.dart';
import 'package:gold_price/controller/bottom_nav_controller.dart';
import 'package:gold_price/controller/gold_shop_controller.dart';
import 'package:gold_price/model/gold.dart';
import 'package:gold_price/ui/page/calulate_page.dart';
import 'package:gold_price/ui/page/gold_editor_page.dart';
import 'package:gold_price/ui/page/home_page.dart';
import 'package:gold_price/util/common_util.dart';
import 'package:provider/provider.dart';

final bodyTags = [
  const HomePage(),
  const GoldEditorPage(),
  const CalculatePage(),
];

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    CommonUtil.doInFuture(() {
      context.read<GoldShopController>().getGoldShopData();
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: GestureDetector(
            onTap: () {},
            child: Consumer<BottomNavController>(
                builder: (_, controller, __) =>
                    bodyTags.elementAt(controller.selectedIndex))),
        endDrawer: _drawerLayout(),
        bottomNavigationBar: bottomNavBar(),
      ),
    );
  }

  Consumer<GoldShopController> bottomNavBar() {
    return Consumer<GoldShopController>(
      builder: (_, goldController, __) => Consumer<BottomNavController>(
          builder: (_, controller, __) => FancyBottomNavigation(
                initialSelection: controller.selectedIndex,
                tabs: [
                  TabData(iconData: Icons.home, title: "Home"),
                  TabData(
                      iconData: Icons.search,
                      title: goldController.currentEditGold.name.isNotEmpty
                          ? "Update"
                          : "Add"),
                  TabData(iconData: Icons.shopping_cart, title: "Calculate")
                ],
                onTabChangedListener: (position) {
                  Gold currentGold = goldController.currentEditGold;
                  if (controller.selectedIndex == 1 &&
                      currentGold.id != '0' &&
                      currentGold.id != '') {
                    _showWarningDialog(controller, position);
                  } else {
                    controller.selectedIndex = position;
                  }
                },
              )),
    );
  }

  void _showWarningDialog(BottomNavController controller, int index) {
    warningDialog(
      context,
      'Current Editing is dismissed data!',
      'Go To',
      () {
        Navigator.of(context).pop();
        controller.selectedIndex = index;
      },
      () {
        var preIndex = controller.selectedIndex;
        controller.selectedIndex = index;
        controller.selectedIndex = preIndex;
        Navigator.of(context).pop();
      },
    );
  }
}

class RightDrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(50, 0);
    path.quadraticBezierTo(0, size.height / 2, 50, size.height);
    // path.lineTo(0, size.height / 2);
    // path.lineTo(50, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

ClipPath _drawerLayout() => ClipPath(
      clipper: RightDrawerClipper(),
      child: Drawer(
        child: Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.all(7),
          child: Column(
            children: [
              const SizedBox(height: 20),
              ascendingToggle(),
              const SizedBox(height: 20),
              checkBoxCustom('Sort by Name', true),
              const SizedBox(height: 20),
              checkBoxCustom('Sort by 16 ပဲရည်‌စျေး', false),
            ],
          ),
        ),
      ),
    );

Row ascendingToggle() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      const Text(
        'Ascending',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
      const SizedBox(
        width: 10,
      ),
      Consumer<GoldShopController>(
        builder: (_, controller, __) => GFToggle(
          boxShape: BoxShape.rectangle,
          disabledTrackColor: Colors.grey.shade400,
          enabledTrackColor: Colors.grey.shade400,
          disabledThumbColor: Colors.green.shade400,
          enabledThumbColor: Colors.grey.shade700,
          onChanged: (isCheck) {
            controller.isAscending = isCheck ?? true;
          },
          borderRadius: BorderRadius.circular(5),
          value: controller.isAscending,
          type: GFToggleType.custom,
        ),
      ),
    ],
  );
}

Widget checkBoxCustom(String title, bool isName) {
  return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
    Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
    ),
    const SizedBox(
      width: 30,
    ),
    Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Consumer<GoldShopController>(
        builder: (_, controller, __) => GFCheckbox(
          size: 21,
          activeBgColor: GFColors.SUCCESS,
          onChanged: (value) {
            controller.isSortByName = isName;
          },
          value: controller.isSortByName == isName,
          inactiveIcon: null,
        ),
      ),
    ),
  ]);
}
