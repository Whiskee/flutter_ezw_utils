import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ezw_utils/flutter_ezw_utils_platform_interface.dart';

class EzwUtils {
  static EzwUtils to = EzwUtils._init();

  EzwUtils._init();

  Future<String?> getPlatformVersion() =>
      EzwUtilsPlatform.instance.getPlatformVersion();

  /// 获取Flutter运行环境信息
  String flutterInfo() {
    //  收集 Flutter 运行时信息
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final view = dispatcher.views.isNotEmpty ? dispatcher.views.first : null;
    final dpr = view?.devicePixelRatio;
    final size = view?.physicalSize;
    final locales = dispatcher.locales.map((e) => e.toLanguageTag()).join(',');
    const buildMode =
        kReleaseMode ? 'release' : (kProfileMode ? 'profile' : 'debug');
    return 'platform=$defaultTargetPlatform, mode=$buildMode, locales=[$locales], brightness=${dispatcher.platformBrightness}, dpr=${dpr != null ? dpr.toStringAsFixed(2) : '-'}, size=${size != null ? '${size.width}x${size.height}' : '-'}, dart=${Platform.version}';
  }
}
