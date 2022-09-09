import 'package:flutter/material.dart';
import '../../util/screen_util.dart';

Widget getErrorImage(BuildContext context) {
  return SizedBox(
    width: ScreenSizeUtil.getScreenWidth(context),
    child: Image.asset(
      'assets/images/no_image_available.jpg',
      color: Colors.grey.withOpacity(0.5),
      colorBlendMode: BlendMode.srcOver,
      fit: BoxFit.cover,
    ),
  );
}
