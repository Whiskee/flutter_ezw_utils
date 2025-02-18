import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  
  /// 点击事件
  Widget onTap(Function() function) => GestureDetector(
        onTap: function,
        child: this,
      );
}
