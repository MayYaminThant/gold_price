import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/gold.dart';

const String dateFormatDayMonthYearHourMinSecond = 'dd/MM/yyyy HH:mm:ss';

Color get grey300 {
  return Colors.grey.shade200;
}

List<String> colors = [
  '#A3BFD4',
  '#C6DAB0',
  '#DABAC3',
  '#D4C6A3',
  '#DAB0B0',
  '#A3D4B9',
  '#D2B0DA',
  '#816F7A',
  '#A37E4D',
  '#C595A5',
  '#C59595',
];

Map<int, Color> colorList = const {
  50: Color.fromRGBO(163, 191, 212, 1),
  100: Color.fromRGBO(198, 218, 176, 2),
  200: Color.fromRGBO(218, 186, 195, 1),
  300: Color.fromRGBO(212, 198, 163, 1),
  400: Color.fromRGBO(218, 176, 176, 1),
  450: Color.fromRGBO(163, 212, 185, 1),
  500: Color.fromRGBO(210, 176, 218, 1),
  600: Color.fromRGBO(129, 111, 122, 1),
  700: Color.fromRGBO(163, 126, 77, 1),
  800: Color.fromRGBO(197, 149, 165, 1),
  900: Color.fromRGBO(197, 149, 149, 1),
};

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

typedef GetGoldCallBack = void Function(Gold gold);
