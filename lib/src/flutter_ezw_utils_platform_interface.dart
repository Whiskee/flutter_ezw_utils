import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ezw_utils_method_channel.dart';

abstract class EzwUtilsPlatform extends PlatformInterface {
  /// Constructs a FlutterEzwUtilsPlatform.
  EzwUtilsPlatform() : super(token: _token);

  static final Object _token = Object();

  static EzwUtilsPlatform _instance = MethodChannelEzwUtils();

  /// The default instance of [FlutterEzwUtilsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterEzwUtils].
  static EzwUtilsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterEzwUtilsPlatform] when
  /// they register themselves.
  static set instance(EzwUtilsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
