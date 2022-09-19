import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../common/common_widget.dart';
import '../../controller/bottom_nav_controller.dart';
import '../../controller/gold_shop_controller.dart';
import '../../model/gold.dart';
import '../../ui/page/calculate_page.dart';
import '../../ui/page/gold_editor_page.dart';
import '../../ui/page/home_page.dart';
import '../../util/common_util.dart';
import 'package:provider/provider.dart';

final bodyTags = [
  const HomePage(),
  const GoldEditorPage(),
  const CalculatePage(),
];

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  Future _refreshCallback() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CommonUtil.doInFuture(() {
      context.read<GoldShopController>().getGoldShopData();
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Container(
          color: Colors.transparent,
          child: RefreshIndicator(
            onRefresh: _refreshCallback,
            backgroundColor: Colors.grey,
            color: Colors.white12,
            displacement: 165,
            strokeWidth: 3,
            child: GestureDetector(
              onTap: () {},
              child: Consumer<BottomNavController>(
                builder: (_, controller, __) =>
                    bodyTags.elementAt(controller.selectedIndex),
              ),
            ),
          ),
        ),
        endDrawer: _drawerLayout(),
        bottomNavigationBar: bottomNavBar(),
      ),
    );
  }

  Consumer<GoldShopController> bottomNavBar() {
    return Consumer<GoldShopController>(
      builder: (_, goldController, __) => Consumer<BottomNavController>(
          builder: (_, controller, __) => BottomNavigationBar(
                selectedItemColor: const Color.fromRGBO(26, 142, 150, 1),
                unselectedItemColor: const Color.fromARGB(255, 130, 191, 173),
                currentIndex: controller.selectedIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: 32),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.add_box, size: 30),
                    label: goldController.currentEditGold.name.isNotEmpty
                        ? "Update"
                        : "Add",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.calculate, size: 30),
                    label: "Calculate",
                  ),
                ],
                onTap: (position) {
                  Gold currentGold = goldController.currentEditGold;
                  if (controller.selectedIndex == 1 &&
                      goldController.isEditing &&
                      currentGold.id != '0' &&
                      currentGold.id != '') {
                    _showWarningDialog(
                      goldController,
                      controller,
                      position,
                    );
                  } else {
                    controller.selectedIndex = position;
                  }
                },
              )),
    );
  }

  void _showWarningDialog(
    GoldShopController goldController,
    BottomNavController controller,
    int index,
  ) {
    warningDialog(
      context,
      'Current Editing is dismissed data!',
      'Go To',
      () {
        Navigator.of(context).pop();
        goldController.currentEditGold = goldController.newGold;
        controller.selectedIndex = index;
      },
      () {
        Navigator.of(context).pop();
        var preIndex = controller.selectedIndex;
        controller.selectedIndex = index;
        controller.selectedIndex = preIndex;
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
      Text(
        'Ascending',
        style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: textHeaderSizeColor),
      ),
      const SizedBox(
        width: 10,
      ),
      Consumer<GoldShopController>(
        builder: (_, controller, __) => GFToggle(
          boxShape: BoxShape.rectangle,
          disabledTrackColor: const Color.fromRGBO(160, 183, 173, 1),
          enabledTrackColor: const Color.fromRGBO(160, 183, 173, 1),
          disabledThumbColor: const Color.fromRGBO(26, 142, 150, 1),
          enabledThumbColor: const Color.fromRGBO(148, 153, 116, 1),
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
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: textHeaderSizeColor,
      ),
    ),
    const SizedBox(
      width: 30,
    ),
    Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Consumer<GoldShopController>(
        builder: (_, controller, __) => GFCheckbox(
          size: 21,
          activeBgColor: const Color.fromARGB(255, 251, 184, 156),
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
