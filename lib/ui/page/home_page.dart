import 'package:flutter/material.dart';
import 'package:gold_price/common/color_extension.dart';
import 'package:gold_price/common/common_widget.dart';
import 'package:gold_price/controller/gold_shop_controller.dart';
import 'package:gold_price/model/gold.dart';
import 'package:gold_price/ui/page/gold_detail.dart';
import 'package:gold_price/util/screen_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            sliverAppBar(),
            SliverToBoxAdapter(
              child: searchAndFilterWidget(context),
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
        ),
      ),
    );
  }

  SliverAppBar sliverAppBar() {
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
            Scaffold.of(context).openEndDrawer();
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
          footer: gridFooter(gold, colorPr),
          child: gridImage(gold, colorPr),
        ),
      ),
    );
  }

  Widget gridImage(Gold gold, Color colorPr) {
    bool isUpRange = (gold.sixteenPriceList.values.length > 2 &&
            (double.parse(gold.sixteenPriceList.values.last) >=
                double.parse(gold.sixteenPriceList.values
                    .elementAt(gold.sixteenPriceList.values.length - 2)))) ||
        (gold.sixteenPriceList.values.length == 1);
    return Container(
      padding: const EdgeInsets.only(top: 20),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorPr,
      ),
      child: Icon(
        isUpRange
            ? Icons.arrow_circle_up_rounded
            : Icons.arrow_circle_down_rounded,
        color: isUpRange ? Colors.red : Colors.yellow,
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

  Widget searchAndFilterWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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

  Container filterWidget() {
    return Container(
      height: 55,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: grey300,
      ),
      child: IconButton(
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
        icon: Icon(
          Icons.filter_list,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
