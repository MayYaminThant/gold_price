import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gold_price/common/common_widget.dart';
import 'package:gold_price/model/gold.dart';
import 'package:gold_price/model/gold_price_rate.dart';
import 'package:gold_price/ui/page/main_page.dart';
import 'package:gold_price/util/screen_util.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GoldDetail extends StatefulWidget {
  const GoldDetail({Key? key, required this.gold}) : super(key: key);

  final Gold gold;

  @override
  State<GoldDetail> createState() => _GoldDetailState();
}

class _GoldDetailState extends State<GoldDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: goldDetailBody(),
        appBar: appBar(),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.grey.shade400.withOpacity(0.7),
      title: Container(
        alignment: Alignment.centerRight,
        child: Text(
          widget.gold.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context, "Backbutton data");
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget goldDetailBody() {
    return Stack(
      children: [
        imageWidget(),
        // backIconWidget(),
        infoWidget(),
      ],
    );
  }

  Positioned imageWidget() {
    return Positioned(
      top: 10,
      width: ScreenSizeUtil.getScreenWidth(context),
      // height: (ScreenSizeUtil.getScreenHeight(context) / 2),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            width: ScreenSizeUtil.getScreenWidth(context) / 1.1,
            height: (ScreenSizeUtil.getScreenHeight(context) / 4.5),
            fit: BoxFit.cover,
            imageUrl: widget.gold.imageUrl,
            cacheKey: widget.gold.id,
            colorBlendMode: BlendMode.dstATop,
            progressIndicatorBuilder: (context, url, _) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Positioned infoWidget() {
    return Positioned(
      bottom: 0,
      top: ScreenSizeUtil.getScreenHeight(context) / 3.9,
      width: ScreenSizeUtil.getScreenWidth(context),
      // height: ScreenSizeUtil.getScreenHeight(context) / 1.7,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            goldDetailInfo(),
            const SizedBox(height: 15),
            chartWidget(),
          ],
        ),
      ),
    );
  }

  Positioned backIconWidget() {
    return Positioned(
      top: 0,
      height: 10,
      child: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MainPage();
              },
            ),
          );
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }

  Container chartWidget() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: grey300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SfCartesianChart(
        legend: Legend(isVisible: true, opacity: 0.7),
        title: ChartTitle(text: 'Weekly Price Analysis'),
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
    );
  }

  Widget goldDetailInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        goldDetailRow('16 ပဲရည်', ': ' + widget.gold.sixteenPrice),
        goldDetailRow('15 ပဲရည်', ': ' + widget.gold.sixteenPrice),
        goldDetailRow('Phone No.', ': ' + widget.gold.phoneNo),
        goldDetailRow('Facebook', ': ' + widget.gold.facebook),
        goldDetailRow('Website', ': ' + widget.gold.website),
        goldDetailRow('Created Date', ': ' + widget.gold.createdDate),
        goldDetailRow('Modified Date', ': ' + widget.gold.modifiedDate),
      ],
    );
  }

  Widget goldDetailRow(key, value) {
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
          detailContainerUI(key),
          detailContainerUI(value),
        ],
      ),
    );
  }

  Container detailContainerUI(String value) {
    return Container(
      padding: const EdgeInsets.all(7),
      width: (ScreenSizeUtil.getScreenWidth(context) / 2) - 30,
      child: Text(
        value,
        style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold),
      ),
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
}
