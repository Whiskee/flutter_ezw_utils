import 'package:flutter/material.dart';
import 'package:flutter_ezw_utils/extension/function_ext.dart';
import 'package:flutter_ezw_utils/flutter_ezw_index.dart';

extension WidgetExt on Widget {
  /// 点击事件
  /// [debounceMs] 防抖时间
  /// [throttleMs] 节流时间
  /// [behavior] 点击事件行为
  Widget onTap(
    VoidCallback onTap, {
    int debounceMs = 0,
    int throttleMs = 200,
    HitTestBehavior behavior = HitTestBehavior.deferToChild,
  }) =>
      GestureDetector(
        onTap: throttleMs > 0
            ? onTap.throttle(throttleMs.milliseconds)
            : debounceMs > 0
                ? onTap.debounce(debounceMs.milliseconds)
                : onTap,
        behavior: behavior,
        child: this,
      );
}
