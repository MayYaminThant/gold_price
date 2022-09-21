import 'package:intl/intl.dart';

class IntlUtils {
  static String formatPrice(String string) {
    double? value = numberUtil(string);
    if (value == null) {
      return string;
    }
    return NumberFormat('#,###.##').format(value);
  }

  static double? numberUtil(String string) {
    return double.tryParse(string);
  }
}
