import 'package:flutter/material.dart';
import 'package:gold_price/common/common_widget.dart';
import 'package:gold_price/util/screen_util.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: MainPage().scaffoldKey,
        appBar: appBar(),
        body: mainPageBody(context),
        drawer: const Drawer(),
      ),
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

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0, // removing the drop shadow
      leading: IconButton(
        onPressed: () {
          // if (MainPage().scaffoldKey.currentState != null) {
          //   _openEndDrawer();
          // }
          Scaffold.of(context).openDrawer();
        },
        icon: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
      ),
      title: const Center(
        child: Text('နောက်ဆုံးရ ရွှေစျေးနှုန်းများ'),
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      // bottom: TabBar(
      //   labelColor: Colors.black,
      //   unselectedLabelColor: Colors.black54,
      //   indicator: MaterialIndicator(
      //     height: 5,
      //     topLeftRadius: 0,
      //     topRightRadius: 0,
      //     bottomLeftRadius: 5,
      //     bottomRightRadius: 5,
      //     horizontalPadding: 25,
      //   ),
      //   tabs: const [
      //     Tab(
      //       child: Text(
      //         '16 ပဲရည်',
      //         style: TextStyle(fontSize: 14.6),
      //       ),
      //     ),
      //     Tab(
      //       child: Text(
      //         '15 ပဲရည်',
      //         style: TextStyle(fontSize: 14.6),
      //       ),
      //     ),
      //   ],
      // ),
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
        children: List.generate(
          10,
          (index) =>
              // Container(
              //   height: itemHeight,
              //   width: itemWidth,
              //   alignment: Alignment.center,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.rectangle,
              //     borderRadius:
              //         const BorderRadius.all(Radius.elliptical(10.0, 20.0)),
              //     color: Colors.grey.withOpacity(0.1),
              //   ),
              //   margin: const EdgeInsets.all(10.0),
              //   child:
              //       // const Text(
              //       //   'ဇွဲထက်',
              //       //   textAlign: TextAlign.center,
              //       //   style: TextStyle(
              //       //     color: Colors.black,
              //       //     fontSize: 12.0,
              //       //     fontFamily: 'helvetica_neue_medium',
              //       //     letterSpacing: 0.59,
              //       //   ),
              //       // ),
              //       Stack(
              //     alignment: Alignment.center,
              //     children: [
              //       Container(
              //         decoration: const BoxDecoration(
              //           image: DecorationImage(
              //             image: NetworkImage(
              //                 'https://i.huffpost.com/gen/2867428/images/o-GOOGLE-WIRELESS-SERVICE-facebook.jpg'),
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //       ),
              //       const Positioned(
              //         bottom: -5,
              //         left: -6,
              //         right: -6,
              //         child: Card(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(8),
              //               topRight: Radius.circular(8),
              //             ),
              //           ),
              //           child: Text(
              //             'ဇွဲထက်',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 12.0,
              //               fontFamily: 'helvetica_neue_medium',
              //               letterSpacing: 0.59,
              //             ),
              //           ),
              //         ),
              //       ),
              //       // Positioned(
              //       //   bottom: 0,
              //       //   child: Container(
              //       //     height: (itemHeight) / 3,
              //       //     width: double.infinity,
              //       //     decoration: BoxDecoration(
              //       //       shape: BoxShape.rectangle,
              //       //       borderRadius: const BorderRadius.all(
              //       //           Radius.elliptical(10.0, 20.0)),
              //       //       color: Colors.black.withOpacity(0.1),
              //       //     ),
              //       //     child: const Text(
              //       //       'ဇွဲထက်',
              //       //       textAlign: TextAlign.center,
              //       //       style: TextStyle(
              //       //         color: Colors.black,
              //       //         fontSize: 12.0,
              //       //         fontFamily: 'helvetica_neue_medium',
              //       //         letterSpacing: 0.59,
              //       //       ),
              //       //     ),
              //       //   ),
              //       // ),
              //     ],
              //   ),
              // ),
              Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: gridViewListGridTile(),
          ),
        ),
      ),
    );
  }

  GridTile gridViewListGridTile() {
    return GridTile(
      child: gridTileChild(),
      footer: gridTileFooter(),
    );
  }

  Container gridTileChild() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7), BlendMode.dstATop),
          image: const NetworkImage(
            'https://i.huffpost.com/gen/2867428/images/o-GOOGLE-WIRELESS-SERVICE-facebook.jpg',
          ),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Column gridTileFooter() {
    return Column(
      children: [
        Center(
          child: Text(
            'ဇွဲထက်',
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
              gridTileBar('16 ပဲရည်', 2500000),
              gridTileBar('15 ပဲရည်', 2200000),
            ],
          ),
        ),
      ],
    );
  }

  GridTileBar gridTileBar(String goldType, int price) {
    return GridTileBar(
      leading: Text(
        goldType,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      title: const Text(''),
      trailing: Text(
        price.toStringAsFixed(0),
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
