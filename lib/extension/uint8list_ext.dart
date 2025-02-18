import 'dart:typed_data';

extension Uint8listExt on Uint8List {

  /// 转十六进制
  String toHexString() => map((byte) => byte.toRadixString(16)).join(" ");

}