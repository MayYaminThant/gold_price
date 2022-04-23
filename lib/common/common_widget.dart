import 'package:flutter/material.dart';

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
