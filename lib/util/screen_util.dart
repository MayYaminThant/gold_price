import 'package:flutter/material.dart';

class ScreenSizeUtil {
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getScreenHeight(BuildContext context) {
    return getScreenSize(context).height;
  }

  static double getScreenWidth(BuildContext context) {
    return getScreenSize(context).width;
  }
}
