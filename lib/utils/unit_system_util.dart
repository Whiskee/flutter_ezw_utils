import 'package:flutter_ezw_utils/flutter_ezw_index.dart';

enum UnitSystem {
  metric,
  imperial;

  /// Get:
  //  - 是否为英制单位制
  bool get isImperial => this == imperial;
  //  - 是否为公制单位制
  bool get isMetric => this == metric;
}

class UnitSystemUtil {
  /// 完全使用英制的国家
  final List<String> _imperialCountries = [
    "US",
    "LR",
    "MM",
    "BS",
    "BZ",
    "KY",
    "PW",
    "GB",
    "UK",
  ];

  static UnitSystemUtil to = UnitSystemUtil._init();

  UnitSystemUtil._init();

  /// 获取当前系统使用的单位制
  UnitSystem getUnitSystem() {
    //  1. 获取当前设备的国家代码
    final countryCode = Get.deviceLocale?.countryCode;
    //  2. 如果国家代码在英制国家列表中，则返回英制单位制, 否则返回公制单位制
    return _imperialCountries.contains(countryCode)
        ? UnitSystem.imperial
        : UnitSystem.metric;
  }
}
