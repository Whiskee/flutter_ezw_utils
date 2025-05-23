import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:flutter_ezw_utils/models/uint_type.dart';

extension Uint8listExt on Uint8List {
  /// 转十六进制
  String toHexString() => map((byte) => byte.toRadixString(16)).join(" ");

  /// 获取 CRC32 校验码
  int toCrc32({int? startIndex, int? endIndex}) {
    int start = startIndex ?? 0;
    int end = endIndex ?? length;
    final newData = sublist(start, end);
    return getCrc32(newData);
  }

  /// 获取 CRC16 校验码
  int toCrc16({int? initialCrc}) {
    int crc = initialCrc ?? 0xFFFF;
    for (int i = 0; i < length; i++) {
      // Java: crc = (byte)(crc >>> 8) | (crc << 8);
      // 字节交换：高字节和低字节互换
      int highByte = (crc >>> 8) & 0xFF; // 获取高字节
      int lowByte = (crc << 8) & 0xFF00; // 低字节移到高位
      crc = lowByte | highByte;
      // 异或运算：将当前字节与CRC寄存器进行异或运算
      crc ^= (this[i] & 0xFF);
      // (byte)(crc & 0xFF) 取低8位，然后无符号右移4位
      int temp1 = (crc & 0xFF) >>> 4;
      crc ^= temp1 & 0xFF;
      // 左移8位再左移4位，相当于左移12位
      int temp2 = (crc << 12) & 0xFFFF;
      crc ^= temp2;
      // 取低8位，左移4位再左移1位，相当于左移5位
      int temp3 = ((crc & 0xFF) << 5) & 0xFFFF;
      crc ^= temp3;
    }
    return crc & 0xFFFF;
  }

  /// 获取int值
  ///
  /// - param [uint] 字节类型
  /// - param [byteOffset] 字节偏移
  /// - param [endian] 字节序
  int toUint({
    UintType uint = UintType.uint8,
    int byteOffset = 0,
    Endian endian = Endian.little,
  }) {
    final byteData = ByteData.sublistView(this);
    switch (uint) {
      case UintType.uint16:
        return byteData.getUint16(byteOffset, endian);
      case UintType.uint32:
        return byteData.getUint32(byteOffset, endian);
      case UintType.uint64:
        return byteData.getUint64(byteOffset, endian);
      default:
        return byteData.getUint8(byteOffset);
    }
  }
}
