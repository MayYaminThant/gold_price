import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gold_price/common/common_widget.dart';
import 'package:gold_price/controller/bottom_nav_controller.dart';
import 'package:gold_price/controller/gold_shop_controller.dart';
import 'package:gold_price/model/gold.dart';
import 'package:gold_price/model/gold_price_rate.dart';
import 'package:gold_price/util/screen_util.dart';
import 'package:intl/intl.dart';
import 'package:linkable/linkable.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main_page.dart';

class GoldDetail extends StatefulWidget {
  const GoldDetail({Key? key, required this.gold}) : super(key: key);
  final Gold gold;

  @override
  _GoldDetailState createState() => _GoldDetailState();
}

class _GoldDetailState extends State<GoldDetail> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController pswController = TextEditingController();
  final GlobalKey<FormState> _keyDialogForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SafeArea(
          child: CustomScrollView(
            scrollBehavior: const ScrollBehavior(),
            slivers: <Widget>[
              sliverAppBar(),
              sliverAppBarForPrice('16 ပဲရည်', ': ' + widget.gold.sixteenPrice),
              sliverAppBarForPrice('15 ပဲရည်', ': ' + widget.gold.fifteenPrice),
              sliverListCard(textTheme, infoView()),
              sliverListCard(textTheme, chartWidget()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showTitleDialog();
          },
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  SliverAppBar sliverAppBar() {
    return SliverAppBar(
      pinned: true,
      stretch: true, // fetchData
      onStretchTrigger: () async {
        setState(() {});
      },
      leading: Consumer<BottomNavController>(
        builder: (_, bController, __) => Consumer<GoldShopController>(
          builder: (_, controller, __) => IconButton(
            onPressed: () {
              bController.selectedIndex = 0;
              controller.currentEditGold = controller.newGold;
              Navigator.pop(context, "Backbutton data");
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
          StretchMode.blurBackground,
        ],
        title: Text(
          widget.gold.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
        background: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                Colors.black54,
                Colors.transparent,
              ])),
          child: Image.network(
            widget.gold.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget sliverAppBarForPrice(String title, String value) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverAppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        expandedHeight: 50.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            detailContainerUI(
              title,
              Colors.black,
              (ScreenSizeUtil.getScreenWidth(context) / 2) - 30,
              ServiceAction.none,
            ),
            detailContainerUI(
              value,
              Colors.black,
              (ScreenSizeUtil.getScreenWidth(context) / 2) - 30,
              ServiceAction.none,
            ),
          ],
        ),
      ),
    );
  }

  SliverList sliverListCard(TextTheme textTheme, Widget widget) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return SizedBox(
            width: ScreenSizeUtil.getScreenWidth(context) - 10,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                //set border radius more than 50% of height and width to make circle
              ),
              elevation: 4.0,
              margin: const EdgeInsets.all(10),
              shadowColor: Colors.black12,
              child: widget,
            ),
          );
        },
        childCount: 1,
      ),
    );
  }

  Widget infoView() {
    return ExpansionTile(
      title: const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text(
          'About',
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      children: [
        goldDetailRow('Phone No.', widget.gold.phoneNo, ServiceAction.phone),
        goldDetailRow('Facebook', widget.gold.facebook, ServiceAction.facebook),
        goldDetailRow('Website', widget.gold.website, ServiceAction.website),
        goldDetailRow(
            'Created Date', widget.gold.createdDate, ServiceAction.none),
        goldDetailRow(
            'Modified Date', widget.gold.modifiedDate, ServiceAction.none),
      ],
    );
  }

  Widget goldDetailRow(key, value, ServiceAction action) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      height: 55,
      decoration: BoxDecoration(
        color: grey300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          detailContainerUI(
            key,
            Colors.grey.shade700,
            (ScreenSizeUtil.getScreenWidth(context) / 3),
            ServiceAction.none,
          ),
          Text(
            ":",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          detailContainerUI(value, Colors.grey.shade700,
              (ScreenSizeUtil.getScreenWidth(context) / 2), action),
        ],
      ),
    );
  }

  Widget detailContainerUIWithLink(String value, ServiceAction action) {
    return ElevatedButton(
        onPressed: () {
          switch (action) {
            case ServiceAction.phone:
              launch("tel:$value");
              break;

            case ServiceAction.facebook:
              launch(value);
              break;

            case ServiceAction.website:
              launch("https://$value", forceWebView: true);
              break;
            default:
          }
        },
        child: Text(value));
  }

  Widget detailContainerUI(
      String value, Color? color, double? width, ServiceAction action) {
    return InkWell(
      onTap: () async {
        switch (action) {
          case ServiceAction.phone:
            launch("tel:$value");
            break;

          case ServiceAction.facebook:
            String fbProtocolUrl;
            if (Platform.isIOS) {
              fbProtocolUrl = 'fb://profile/page_id';
            } else {
              fbProtocolUrl = 'fb://page/page_id';
            }
            try {
              bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

              if (!launched) {
                await launch(value);
              }
            } catch (e) {
              await launch(value);
            }
            break;

          case ServiceAction.website:
            launch("https://$value", forceWebView: true);
            break;
          default:
        }
      },
      child: Container(
        padding: const EdgeInsets.all(7),
        width: width,
        child: Linkable(
          text: value,
          style: TextStyle(
              fontSize: 16, color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget chartWidget() {
    return ExpansionTile(
      title: const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text(
          'Weekly Price Analysis',
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      children: [
        SfCartesianChart(
          legend: Legend(isVisible: true, opacity: 0.7),
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
              interval: 5,
              majorGridLines: const MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift),
          primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.simpleCurrency(
              decimalDigits: 0,
              locale: 'myan-mm',
              name: 'Ks',
            ),
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
          ),
          series: _getSplieAreaSeries(),
        ),
      ],
    );
  }

  /// Returns the list of chart series
  /// which need to render on the spline area chart.
  List<ChartSeries<GoldPriceRate, double>> _getSplieAreaSeries() {
    final List<GoldPriceRate> chartData = getChartData();

    return <ChartSeries<GoldPriceRate, double>>[
      SplineSeries<GoldPriceRate, double>(
        dataSource: chartData,
        splineType: SplineType.cardinal,
        cardinalSplineTension: 2,
        color: const Color.fromRGBO(197, 154, 81, 0.6),
        xValueMapper: (GoldPriceRate sales, _) => sales.day,
        yValueMapper: (GoldPriceRate sales, _) => sales.price,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        isVisibleInLegend: false,
      ),
    ];
  }

  List<GoldPriceRate> getChartData() {
    final List<GoldPriceRate> chartData = [
      GoldPriceRate(0, 2500000),
      GoldPriceRate(5, 1200000),
      GoldPriceRate(10, 2400000),
      GoldPriceRate(15, 2500000),
      GoldPriceRate(20, 1800000),
      GoldPriceRate(25, 3000000),
    ];
    return chartData;
  }

  Future showTitleDialog() {
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
                    goToGoldEditorPage();
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                goToGoldEditorPage();
              },
              child: const Text('Save'),
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

  void goToGoldEditorPage() {
    if (_keyDialogForm.currentState != null &&
        _keyDialogForm.currentState!.validate()) {
      _keyDialogForm.currentState!.save();

      GoldShopController.checkGoldPassword(
        widget.gold.id,
        pswController.text,
        () {
          pswController.text = "";
          Navigator.pop(context);
          context.read<BottomNavController>().selectedIndex = 1;
          context.read<GoldShopController>().currentEditGold = widget.gold;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const MainPage();
              },
            ),
          );
        },
        () {
          Navigator.pop(context);
        },
      );
    }
  }
}

enum ServiceAction { none, phone, facebook, website }
