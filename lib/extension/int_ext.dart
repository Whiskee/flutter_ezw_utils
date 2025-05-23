import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_ezw_utils/models/uint_type.dart';

/// 视图组建扩张
extension WidgetIntExt on int {
  Widget get widthBox => SizedBox(width: toDouble());
  Widget get heightBox => SizedBox(height: toDouble());
}

/// Uint8List 扩展
extension Uint8ListExt on int {
  /// 将int值转化成指定字节长度的Uint8List
  Uint8List toBytes(
      {UintType uint = UintType.uint8, Endian endian = Endian.little}) {
    final bytes = Uint8List(uint.byteLength);
    final byteData = ByteData.view(bytes.buffer);
    switch (uint) {
      case UintType.uint8:
        byteData.setUint8(0, this & 0xFF);
        break;
      case UintType.uint16:
        byteData.setUint16(0, this & 0xFFFF, endian);
        break;
      case UintType.uint32:
        byteData.setUint32(0, this & 0xFFFFFFFF, endian);
        break;
      case UintType.uint64:
        byteData.setUint64(0, this, endian);
        break;
    }
    return bytes;
  }
}
