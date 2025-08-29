import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

extension WidgetDoubleExt on double {
  //  宽度
  Widget get widthBox => SizedBox(width: this);

  //  高度
  Widget get heightBox => SizedBox(height: this);

  /// 保留小数：方案1
  String formatDouble({int precision = 1}) =>
      this % 1 == 0 ? toInt().toString() : toStringAsFixed(precision); // 保留一位小数

  /// 保留小数：方案2
  String formatDouble2({String format = "#.#"}) =>
      NumberFormat(format).format(this);
}
