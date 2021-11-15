import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:gold_price/common/color_extension.dart';
import 'package:gold_price/common/common_widget.dart';
import 'package:gold_price/controller/gold_shop_controller.dart';
import 'package:gold_price/model/gold.dart';
import 'package:gold_price/ui/page/gold_detail.dart';
import 'package:gold_price/util/common_util.dart';
import 'package:gold_price/util/screen_util.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CommonUtil.doInFuture(() {
      context.read<GoldShopController>().getGoldShopData();
    });
    return SafeArea(
      child: Scaffold(
        key: widget.scaffoldKey,
        backgroundColor: Colors.white,
        body: GestureDetector(
            onTap: () {}, child: mainPageBody(widget.scaffoldKey, context)),
        endDrawer: _drawerLayout(),
      ),
    );
  }

  Widget mainPageBody(scaffoldKey, BuildContext context) {
    return CustomScrollView(
      slivers: [
        sliverAppBar(scaffoldKey),
        SliverToBoxAdapter(
          child: searchAndFilterWidget(context, scaffoldKey),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: Consumer<GoldShopController>(
              builder: (_, controller, __) => SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.7,
                    ),
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: gridChild(
                          controller.filterGoldShopLst.elementAt(index),
                        ),
                      );
                    }, childCount: controller.filterGoldShopLst.length),
                  )),
        )
      ],
    );
  }

  SliverAppBar sliverAppBar(scaffoldKey) {
    return SliverAppBar(
      elevation: 0,
      pinned: true,
      // stretch: true,
      // onStretchTrigger: () async {
      //   setState(() {});
      // },
      actions: [
        IconButton(
          onPressed: () {
            if (scaffoldKey.currentState != null) {
              scaffoldKey.currentState!.openEndDrawer();
            }
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
      ],
      backgroundColor: Colors.white,
      flexibleSpace: const FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'နောက်ဆုံးရ ရွှေစျေးနှုန်းများ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget gridChild(Gold gold) {
    Color colorPr = ColorExtension.fromHex(gold.color);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return GoldDetail(gold: gold);
            },
          ),
        );
      },
      child: SizedBox(
        child: GridTile(
          child: gridImage(gold, colorPr),
          footer: gridFooter(gold, colorPr),
        ),
      ),
    );
  }

  Widget gridImage(Gold gold, Color colorPr) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorPr,
      ),
      child: const Icon(
        Icons.arrow_circle_up_rounded,
        color: Colors.red,
        size: 40,
      ),
    );
  }

  Widget gridFooter(Gold gold, Color colorPr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            gold.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.fill
                ..strokeWidth = 0.7
                ..color = Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              gridTileBar('16', gold.sixteenPrice, colorPr), // ပဲရည်
              gridTileBar('15', gold.fifteenPrice, colorPr),
            ],
          ),
        ),
      ],
    );
  }

  GridTileBar gridTileBar(String goldType, String? price, Color colorPr) {
    return GridTileBar(
      leading: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colorPr,
        ),
        child: Text(
          goldType,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        price ?? '',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget searchAndFilterWidget(BuildContext context, scaffoldKey) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          searchWidget(context),
          filterWidget(scaffoldKey),
        ],
      ),
    );
  }

  Container searchWidget(BuildContext context) {
    return Container(
      height: 55,
      width: ScreenSizeUtil.getScreenWidth(context) - 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: grey300,
      ),
      child: Consumer<GoldShopController>(
        builder: (_, goldController, __) => Row(
          children: [
            IconButton(
              icon: Icon(
                goldController.searchTerm.isEmpty
                    ? Icons.search
                    : Icons.close_rounded,
                color: Colors.grey.shade700,
              ),
              onPressed: () {
                if (goldController.searchTerm.isNotEmpty) {
                  goldController.searchTerm = '';
                  _textController.clear();
                }
              },
            ),
            Expanded(
              child: TextField(
                onSubmitted: (searchStr) {
                  goldController.searchTerm = searchStr;
                },
                cursorColor: Colors.black38,
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(
                      left: 15, bottom: 11, top: 11, right: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container filterWidget(scaffoldKey) {
    return Container(
      height: 55,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: grey300,
      ),
      child: IconButton(
        onPressed: () {
          if (scaffoldKey.currentState != null) {
            scaffoldKey.currentState!.openEndDrawer();
          }
        },
        icon: Icon(
          Icons.filter_list,
          color: Colors.grey.shade700,
        ),
      ),
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

class LeftDrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 50);
    // path.quadraticBezierTo(0, size.height / 3, 30, size.height);
    path.lineTo(0, 50);
    path.lineTo(50, size.height);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 50);

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
