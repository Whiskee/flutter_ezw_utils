import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_ezw_utils_platform_interface.dart';

/// An implementation of [FlutterEzwUtilsPlatform] that uses method channels.
class MethodChannelEzwUtils extends EzwUtilsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ezw_utils');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
