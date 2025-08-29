import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

extension WidgetDoubleExt on double {
  //  宽度
  Widget get widthBox => SizedBox(width: this);

  //  高度
  Widget get heightBox => SizedBox(height: this);

  /// 保留小数
  String formatDouble({String format = "#.#"}) =>
      NumberFormat(format).format(this);
}
