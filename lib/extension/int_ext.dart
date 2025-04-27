import 'dart:typed_data';

import 'package:flutter/widgets.dart';

extension BytesIntExt on int {
  // 将 int 转换为 4 字节 List<int>
  List<int> toFourBytes() => [
        (this >> 24) & 0xFF,
        (this >> 16) & 0xFF,
        (this >> 8) & 0xFF,
        this & 0xFF,
      ];
}

extension Uin8ListExt on int {
  /// 将int转换为指定字节长度的Uint8List
  Uint8List toUint8List(int byteLength) {
    // 创建一个指定字节长度的ByteData
    final byteData = ByteData(byteLength);
    // 根据字节长度将值写入ByteData中
    switch (byteLength) {
      case 1:
        byteData.setInt8(0, this);
        break;
      case 2:
        byteData.setInt16(0, this, Endian.little);
        break;
      case 4:
        byteData.setInt32(0, this, Endian.little);
        break;
      case 8:
        byteData.setInt64(0, this, Endian.little);
        break;
      default:
        throw ArgumentError('toUint8List Unsupported byte length: $byteLength');
    }
    // 转换ByteData为Uint8List
    return byteData.buffer.asUint8List();
  }
}

extension WidgetIntExt on int {
  Widget get widthBox => SizedBox(width: toDouble());
  Widget get heightBox => SizedBox(height: toDouble());
}
