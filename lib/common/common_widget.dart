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
