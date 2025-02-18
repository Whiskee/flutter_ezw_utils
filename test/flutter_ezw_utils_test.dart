import 'package:flutter_ezw_utils/flutter_ezw_utils.dart';
import 'package:flutter_ezw_utils/src/flutter_ezw_utils_method_channel.dart';
import 'package:flutter_ezw_utils/src/flutter_ezw_utils_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterEzwUtilsPlatform
    with MockPlatformInterfaceMixin
    implements EzwUtilsPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EzwUtilsPlatform initialPlatform = EzwUtilsPlatform.instance;

  test('$MethodChannelEzwUtils is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEzwUtils>());
  });

  test('getPlatformVersion', () async {
    EzwUtils flutterEzwUtilsPlugin = EzwUtils();
    MockFlutterEzwUtilsPlatform fakePlatform = MockFlutterEzwUtilsPlatform();
    EzwUtilsPlatform.instance = fakePlatform;
    expect(await flutterEzwUtilsPlugin.getPlatformVersion(), '42');
  });
}
