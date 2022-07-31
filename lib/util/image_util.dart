import 'package:flutter/material.dart';
import 'package:gold_price/util/screen_util.dart';

Widget getErrorImage(BuildContext context) {
  return SizedBox(
    width: ScreenSizeUtil.getScreenWidth(context),
    child: Image.asset(
      'assets/images/4.jpg',
      color: Colors.grey.withOpacity(0.5),
      colorBlendMode: BlendMode.srcOver,
      fit: BoxFit.cover,
    ),
  );
}
