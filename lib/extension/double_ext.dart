import 'package:flutter/widgets.dart';

extension WidgetDoubleExt on double {
  Widget get widgetBox => SizedBox(width: this); 
  Widget get heightBox => SizedBox(height: this);
}
