import 'package:flutter/widgets.dart';

extension IntExt on int {
  Duration get day => Duration(days: this);
  Duration get hour => Duration(hours: this);
  Duration get minute => Duration(minutes: this);
  Duration get second => Duration(seconds: this);
  Duration get milliseconds => Duration(milliseconds: this);
  Duration get microseconds => Duration(microseconds: this);
}

extension WidgetIntExt on int {
  Widget get widgetBox => SizedBox(width: toDouble());
  Widget get heightBox => SizedBox(height: toDouble());
}
