part of '../flutter_ezw_utils.dart';

class EzwUtils {
  Future<String?> getPlatformVersion() =>
      EzwUtilsPlatform.instance.getPlatformVersion();
}
