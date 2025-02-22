import 'package:flutter_ezw_utils/flutter_ezw_utils_platform_interface.dart';

class EzwUtils {
  Future<String?> getPlatformVersion() =>
      EzwUtilsPlatform.instance.getPlatformVersion();
}
