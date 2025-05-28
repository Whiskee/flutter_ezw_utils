import 'dart:async';

/// 扩展Function，添加防抖功能
extension DebounceExtension on Function {
  /// 防抖
  /// [duration] 防抖时间
  void Function() debounce(
      [Duration duration = const Duration(milliseconds: 500)]) {
    Timer? debounceTimer;
    return () {
      if (debounceTimer?.isActive ?? false) {
        debounceTimer?.cancel();
      }
      debounceTimer = Timer(duration, () => this());
    };
  }
}

// 扩展Function，添加节流功能
extension ThrottleExtension on Function {
  // 无参数函数的节流
  void Function() throttle(
      [Duration duration = const Duration(milliseconds: 300)]) {
    bool isAllowed = true;
    Timer? throttleTimer;
    return () {
      if (!isAllowed) {
        return;
      }
      isAllowed = false;
      this(); // 无参数函数的调用
      throttleTimer?.cancel();
      throttleTimer = Timer(duration, () => isAllowed = true);
    };
  }

  // 带参数函数的节流
  void Function(dynamic) throttleWithArgs(
      [Duration duration = const Duration(milliseconds: 300)]) {
    bool isAllowed = true;
    Timer? throttleTimer;
    return (dynamic argument) {
      if (!isAllowed) {
        return;
      }
      isAllowed = false;
      Function.apply(this, [argument]); // 带参数函数的调用
      throttleTimer?.cancel();
      throttleTimer = Timer(duration, () => isAllowed = true);
    };
  }
}
