import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/gold.dart';
import 'color_extension.dart';

const String dateFormatDayMonthYearHourMinSecond = 'dd/MM/yyyy HH:mm:ss';

Color get grey300 {
  return Colors.grey.shade200;
}

List<String> colors = [
  '#b1d0d9',
  '#64b0bb',
  '#78b9c8',
  '#91c5c2',
  '#f7cfae',
  '#bbd9ec',
  '#d0f1f0',
  '#c2eff1',
  '#77a4c2',
  '#96a39d',
  '#b19393',
];

warningDialog(
  BuildContext context,
  String title,
  String submitLabel,
  VoidCallback submitCallback,
  VoidCallback cancelCallback,
) {
  // BuildContext dialogContext;
  return showDialog(
      context: context,
      builder: (BuildContext bContext) {
        // dialogContext = bContext;
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                submitCallback.call();
              },
              child: Text(submitLabel),
            ),
            ElevatedButton(
                onPressed: () async {
                  cancelCallback.call();
                },
                child: const Text('Cancel')),
          ],
        );
      });
}

void showSimpleSnackBar(
  BuildContext context,
  String text,
  Color bgColor, {
  VoidCallback? dismissCallback,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: (bgColor),
      action: SnackBarAction(
        label: 'dismiss',
        onPressed: dismissCallback ?? () {},
      ),
    ),
  );
}

Future<void> makePhoneCall(BuildContext context, String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  try {
    await launchUrl(launchUri);
  } catch (e) {
    showSimpleSnackBar(context, 'Could not launch $phoneNumber', Colors.red);
  }
}

Future<void> launchInBrowser(
  BuildContext context,
  String url, {
  LaunchMode mode = LaunchMode.externalApplication,
}) async {
  try {
    await launchUrlString(url, mode: mode);
  } catch (e) {
    showSimpleSnackBar(context, 'Could not launch $url', Colors.red);
  }
}

getModifiedDateFormat(value) {
  return getDateWithCustomFormat(value, 'yyyy-MM-dd');
}

getDateWithCustomFormat(value, String datePattern) {
  DateTime? dateParse;
  if (value != null && value.runtimeType == DateTime) {
    // var date = value.toString();
    dateParse = value;
  } else if (value != null) {
    var date = value.toDate().toString();
    dateParse = DateFormat(datePattern).parse(date);
  }
  var dateFormat =
      dateParse != null ? DateFormat(datePattern).format(dateParse) : '';
  return dateFormat;
}

Map<String, String> sortPriceListMapByDate(Map<String, String> priceList) {
  SplayTreeMap<String, String>.from(priceList, (keys1, keys2) {
    DateTime dt1 = DateFormat(dateFormatDayMonthYearHourMinSecond).parse(keys1);
    DateTime dt2 = DateFormat(dateFormatDayMonthYearHourMinSecond).parse(keys2);
    return dt2.compareTo(dt1);
  });
  return priceList;
}

typedef GetGoldCallBack = void Function(Gold gold);

Color get textHeaderSizeColor => const Color.fromRGBO(21, 76, 121, 1);

Color get appBarIconColor => ColorExtension.fromHex(colors[10]);
