import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common/common_widget.dart';
import '../../controller/bottom_nav_controller.dart';
import '../../controller/gold_shop_controller.dart';
import '../../model/gold.dart';
import '../../model/gold_price_rate.dart';
import '../../util/screen_util.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../util/common_util.dart';
import '../../util/image_util.dart';
import 'main_page.dart';

class GoldDetail extends StatefulWidget {
  const GoldDetail({Key? key}) : super(key: key);

  @override
  GoldDetailState createState() => GoldDetailState();
}

class GoldDetailState extends State<GoldDetail> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController pswController = TextEditingController();
  final GlobalKey<FormState> _keyDialogForm = GlobalKey<FormState>();
  @override
  void dispose() {
    titleController.dispose();
    pswController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Gold gold = context.read<GoldShopController>().goldForDetail;
    CommonUtil.doInFuture(() {
      gold = context.read<GoldShopController>().goldForDetail;
      setState(() {});
    });
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SafeArea(
          child: CustomScrollView(
            scrollBehavior: const ScrollBehavior(),
            slivers: <Widget>[
              sliverAppBar(gold),
              sliverAppBarForPrice(
                '16 ပဲရည်',
                ': ${gold.sixteenPrice}',
                gold.color,
              ),
              sliverAppBarForPrice(
                '15 ပဲရည်',
                ': ${gold.fifteenPrice}',
                gold.color,
              ),
              sliverListCard(infoView(gold), gold.color),
              // sliverListCard(
              //   textTheme,
              //   // SizedBox(
              //   //   width: double.infinity,
              //   //   child: SingleChildScrollView(
              //   //     scrollDirection: Axis.horizontal,
              //   //     child:
              //   chartWidget(gold.sixteenPriceList),
              //   //   ),
              //   // ),
              // ),
              const SliverPadding(
                sliver: SliverToBoxAdapter(
                    child: SizedBox(
                  height: 50,
                )),
                padding: EdgeInsets.all(0),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showPasswordConfirmationDialog(submittedCallback: () {
              goToGoldEditorPage(gold);
            });
          },
          backgroundColor: Colors.pink[50],
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  SliverAppBar sliverAppBar(Gold gold) {
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
            icon: Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: appBarIconColor,
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
          gold.name,
          style: TextStyle(
            color: appBarIconColor,
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
            gold.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => getErrorImage(context),
          ),
        ),
      ),
      actions: [
        _deleteShopUIAndAction(gold),
      ],
    );
  }

  Consumer<GoldShopController> _deleteShopUIAndAction(Gold gold) {
    return Consumer<GoldShopController>(
      builder: (_, controller, __) => IconButton(
          onPressed: () {
            _showPasswordConfirmationDialog(submittedCallback: () {
              controller.deleteGoldData(
                gold.id,
                successCallback: () {
                  Navigator.pop(context);
                  showSimpleSnackBar(
                    context,
                    'Delete Successful',
                    Colors.green.shade200,
                  );
                },
                failureCallback: (dynamic error) {
                  Navigator.pop(context);
                  showSimpleSnackBar(
                    context,
                    'Delete Failed: $error',
                    Colors.green.shade200,
                  );
                },
              );
            });
          },
          icon: Icon(
            Icons.delete_forever_rounded,
            size: 30,
            color: appBarIconColor,
          )),
    );
  }

  Widget sliverAppBarForPrice(String title, String value, String color) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverAppBar(
        backgroundColor: appBarIconColor,
        automaticallyImplyLeading: false,
        expandedHeight: 50.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _detailContainerUI(
              title,
              Colors.white,
              (ScreenSizeUtil.getScreenWidth(context) / 2) - 30,
              ServiceAction.none,
              16,
              FontWeight.bold,
            ),
            _detailContainerUI(
              value,
              Colors.white,
              (ScreenSizeUtil.getScreenWidth(context) / 2) - 30,
              ServiceAction.none,
              15,
              FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  SliverList sliverListCard(Widget widget, String color) {
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
              color: appBarIconColor,
              child: widget,
            ),
          );
        },
        childCount: 1,
      ),
    );
  }

  Widget infoView(Gold gold) {
    return ExpansionTile(
      title: const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text(
          'About',
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      initiallyExpanded: true,
      children: [
        const DottedLine(
          dashColor: Colors.white,
          lineThickness: 1,
          dashLength: 6,
        ),
        goldDetailRow('Phone No.', gold.phoneNo, ServiceAction.phone),
        goldDetailRow('Facebook', gold.facebook, ServiceAction.facebook),
        goldDetailRow('Website', gold.website, ServiceAction.website),
        goldDetailRow('Created Date', gold.createdDate, ServiceAction.none),
        goldDetailRow('Modified Date', gold.modifiedDate, ServiceAction.none),
      ],
    );
  }

  Widget goldDetailRow(key, value, ServiceAction action) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.only(left: 2.0),
      height: 60,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailContainerUI(
            key,
            Colors.grey.shade700,
            (ScreenSizeUtil.getScreenWidth(context) / 3),
            ServiceAction.none,
            16,
            FontWeight.w500,
          ),
          _detailContainerUI(
            value,
            action == ServiceAction.none ? Colors.white : Colors.blue[600],
            (ScreenSizeUtil.getScreenWidth(context) / 2),
            action,
            15,
            FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget _detailContainerUI(
    String value,
    Color? color,
    double? width,
    ServiceAction action,
    double titleFontSize,
    FontWeight fontWeight,
  ) {
    return InkWell(
      onTap: () async {
        switch (action) {
          case ServiceAction.phone:
            makePhoneCall(context, value);
            break;

          case ServiceAction.facebook:
            String fbProtocolUrl;
            if (Platform.isIOS) {
              fbProtocolUrl = 'fb://profile/page_id';
            } else {
              fbProtocolUrl = 'fb://page/page_id';
            }
            launchInBrowser(context, fbProtocolUrl);
            break;

          case ServiceAction.website:
            launchInBrowser(context, value);
            break;
          default:
        }
      },
      child: Container(
        padding: const EdgeInsets.all(3),
        // width: width,
        child: Text(
          value,
          style: TextStyle(
            fontSize: titleFontSize,
            color: color,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }

  Widget chartWidget(Map<String, String> sixteenPriceList) {
    return ExpansionTile(
      title: const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text(
          'Weekly Price Analysis',
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      initiallyExpanded: true,
      children: [
        SfCartesianChart(
          legend: Legend(isVisible: true, opacity: 0.7),
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
              // interval: 5,
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
          series: _getSplieAreaSeries(sixteenPriceList),
        ),
      ],
    );
  }

  /// Returns the list of chart series
  /// which need to render on the spline area chart.
  List<ChartSeries<GoldPriceRate, int>> _getSplieAreaSeries(
      Map<String, String> sixteenPriceList) {
    final List<GoldPriceRate> chartData = getChartData(sixteenPriceList);

    return <ChartSeries<GoldPriceRate, int>>[
      SplineSeries<GoldPriceRate, int>(
        dataSource: chartData,
        splineType: SplineType.cardinal,
        cardinalSplineTension: 2,
        color: const Color.fromRGBO(197, 154, 81, 0.6),
        xValueMapper: (GoldPriceRate sales, _) =>
            sales.date.millisecondsSinceEpoch,
        yValueMapper: (GoldPriceRate sales, _) => sales.price,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        isVisibleInLegend: false,
      ),
    ];
  }

  List<GoldPriceRate> getChartData(Map<String, String> sixteenPriceList) {
    final List<GoldPriceRate> chartData = [];
    sixteenPriceList.forEach((key, value) {
      chartData.add(GoldPriceRate(
          DateFormat(dateFormatDayMonthYearHourMinSecond).parse(key),
          double.parse(value)));
    });
    return chartData;
  }

  Future _showPasswordConfirmationDialog(
      {required VoidCallback submittedCallback}) {
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
                    submittedCallback.call();
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                submittedCallback.call();
              },
              child: const Text('Confirm'),
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

  void goToGoldEditorPage(Gold gold) {
    if (_keyDialogForm.currentState != null &&
        _keyDialogForm.currentState!.validate()) {
      _keyDialogForm.currentState!.save();

      GoldShopController.checkGoldPassword(
        gold.id,
        pswController.text,
        () {
          pswController.text = "";
          Navigator.pop(context);
          context.read<BottomNavController>().selectedIndex = 1;
          context.read<GoldShopController>().currentEditGold = gold;
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
          var psw = pswController.text;
          pswController.text = "";
          showSimpleSnackBar(
              context, "Your password($psw) is invalid!", Colors.red);
          Navigator.pop(context);
        },
      );
    }
  }
}

enum ServiceAction { none, phone, facebook, website }
