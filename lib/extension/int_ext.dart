import 'package:flutter/widgets.dart';

extension WidgetIntExt on int {
  Widget get widgetBox => SizedBox(width: toDouble());
  Widget get heightBox => SizedBox(height: toDouble());
}
