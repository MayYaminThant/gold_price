import 'package:flutter/material.dart';
import 'package:gold_price/common/common_widget.dart';
import 'package:gold_price/controller/gold_shop_controller.dart';
import 'package:gold_price/model/gold.dart';
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
  @override
  Widget build(BuildContext context) {
    CommonUtil.doInFuture(() {
      context.read<GoldShopController>().getGoldShopData();
    });
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: appBar(widget.scaffoldKey),
      body: mainPageBody(context),
      endDrawer: _drawerLayout(),
    );
  }

  SafeArea mainPageBody(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          children: [
            searchAndFilterWidget(context),
            const SizedBox(height: 10),
            gridViewWidgetList(),
          ],
        ),
      ),
    );
  }

  AppBar appBar(GlobalKey<ScaffoldState> scaffoldKey) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0, // removing the drop shadow
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
      title: const Center(
        child: Text('နောက်ဆုံးရ ရွှေစျေးနှုန်းများ'),
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    );
  }

  Widget gridViewWidgetList() {
    final double itemHeight =
        (ScreenSizeUtil.getScreenHeight(context) - kToolbarHeight - 100) / 2;
    final double itemWidth = ScreenSizeUtil.getScreenWidth(context) / 2;
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: (itemWidth / itemHeight),
        shrinkWrap: true,
        children: [
          Consumer<GoldShopController>(
            builder: (_, controller, __) {
              return SizedBox(
                // Added this widget
                width: 300,
                height: 300,
                child: ListView.builder(
                  itemCount: controller.goldShopLst.length,
                  itemBuilder: (_, index) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: gridViewListGridTile(
                      controller.goldShopLst.elementAt(index),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget gridViewListGridTile(Gold gold) {
    return SizedBox(
      // Added this widget
      width: 300,
      height: 300,
      child: GridTile(
        child: gridTileChild(gold),
        footer: gridTileFooter(gold),
      ),
    );
  }

  Widget gridTileChild(Gold gold) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff7c94b6),
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.dstATop),
            image: NetworkImage(
              gold.imageUrl,
            ),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Column gridTileFooter(Gold gold) {
    return Column(
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
            color: Colors.black45.withOpacity(0.35),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              gridTileBar('16 ပဲရည်', gold.sixteenPrice),
              gridTileBar('15 ပဲရည်', gold.fifteenPrice),
            ],
          ),
        ),
      ],
    );
  }

  GridTileBar gridTileBar(String goldType, String? price) {
    return GridTileBar(
      leading: Text(
        goldType,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      title: const Text(''),
      trailing: Text(
        price ?? '',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  SizedBox searchAndFilterWidget(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          searchWidget(context),
          filterWidget(),
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
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.grey.shade700,
            ),
          ),
          Expanded(
            child: TextField(
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
    );
  }

  Container filterWidget() {
    return Container(
      height: 55,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: grey300,
      ),
      child: IconButton(
        onPressed: () {},
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
          color: Colors.grey,
        ),
      ),
    );
