import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
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
  GoldEditorPage(),
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
        builder: (_, controller, __) => CurvedNavigationBar(
          // key: _bottomNavigationKey,
          index: controller.selectedIndex,
          height: 50.0,
          items: <Widget>[
            bottomNavIcon(Icons.home, controller.selectedIndex == 0),
            bottomNavIcon(Icons.add, controller.selectedIndex == 1),
            bottomNavIcon(Icons.calculate, controller.selectedIndex == 2),
          ],
          color: Colors.grey.shade400,
          buttonBackgroundColor: Colors.blue,
          backgroundColor: Colors.white,
          animationCurve: Curves.ease,
          animationDuration: const Duration(milliseconds: 600),
          onTap: (index) {
            Gold currentGold = goldController.currentEditGold;
            if (controller.selectedIndex == 1 &&
                (currentGold.id != '' && currentGold.id != '0')) {
              showWarningDialog(controller, index);
            } else {
              controller.selectedIndex = index;
            }
          },
        ),
      ),
    );
  }

  Widget bottomNavIcon(IconData icon, bool isSelected) {
    return Icon(icon,
        size: 25, color: (isSelected ? Colors.white : Colors.black));
  }

  Future showWarningDialog(BottomNavController controller, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Current Editing is dismissed data!'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.selectedIndex = index;
                },
                child: const Text('Go To'),
              ),
              ElevatedButton(
                  onPressed: () {
                    var preIndex = controller.selectedIndex;
                    Navigator.pop(context);
                    controller.selectedIndex = index;
                    controller.selectedIndex = preIndex;
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
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
