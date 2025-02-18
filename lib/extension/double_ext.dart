import 'package:flutter/widgets.dart';

extension DoubleExt on double {
  Duration get day {
    int days = toInt();
    double remainingFraction = this - days;
    int hours = (remainingFraction * 24).toInt();
    return Duration(days: days, hours: hours);
  }

  Duration get hour {
    int hours = toInt();
    double remainingFraction = this - hours;
    int minutes = (remainingFraction * 60).toInt();
    return Duration(hours: hours, minutes: minutes);
  }

  Duration get seconds {
    int seconds = toInt();
    double remainingFraction = this - seconds;
    int minutes = (remainingFraction * 1000000).toInt();
    return Duration(seconds: seconds, microseconds: minutes);
  }

  Duration get microseconds => Duration(microseconds: toInt());

  Duration get milliseconds => Duration(milliseconds: toInt());
}

extension WidgetDoubleExt on double {
  Widget get widgetBox => SizedBox(width: this); 
  Widget get heightBox => SizedBox(height: this);
}
