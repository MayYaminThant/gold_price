import 'package:flutter/material.dart';

class CommonUtil {
  static void doInFuture(VoidCallback callback) {
    Future.delayed(Duration.zero, callback);
  }
}
