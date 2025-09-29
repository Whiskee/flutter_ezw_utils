import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_ezw_utils/flutter_ezw_index.dart';

extension ListIntExt on List<int> {
  // 将 List<int> 转换为十六进制字符串
  String toHexString() {
    final buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      // 获取 int16 值
      int value = this[i];
      // 将 int16 值视为无符号的16位数，以获取其两字节的十六进制表示
      // 0xFFFF 是 16位的掩码 (1111111111111111 in binary)
      // & 操作符确保我们得到的是16位无符号整数的正确表示
      String hex = (value & 0xFFFF).toRadixString(16).padLeft(4, '0');
      buffer.write(hex);
    }
    return buffer.toString();
  }

  //  转Uint8List
  Uint8List toUint8List() => Uint8List.fromList(this);

  //  字节转字符
  String decodeToString() {
    try {
      // 首先使用标准方法解码
      String result = utf8.decode(this);
      // 移除所有 null 字符和其他控制字符
      return result.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '').trim();
    } catch (e) {
      // 如果解码失败，尝试直接从字节构建字符串
      List<int> validBytes =
          this.where((byte) => byte > 0 && byte < 127).toList();
      return String.fromCharCodes(validBytes);
    }
  }

  // 将 List<int> 转换为 int (支持大小端序)
  int toInt({
    int bitWidth = 8,
    Endian endian = Endian.little,
  }) {
    //  1. 如果列表为空，返回0
    if (isEmpty) {
      return 0;
    }
    //  2、确保数据长度足够
    int bytesNeeded = (bitWidth / 8).ceil();
    if (length < bytesNeeded) {
      return -1;
    }
    //  3、创建 Uint8List 和 ByteData
    final uint8List = Uint8List.fromList(this.take(bytesNeeded).toList());
    final byteData = ByteData.view(uint8List.buffer);
    //  4、根据位宽读取相应的整数
    switch (bitWidth) {
      case 8:
        return byteData.getInt8(0);
      case 16:
        return byteData.getInt16(0, endian);
      case 32:
        return byteData.getInt32(0, endian);
      case 64:
        // Dart的int是64位的，但在某些平台上可能会有精度问题
        return byteData.getInt64(0, endian);
      default:
        // 对于非标准位宽，使用手动实现
        int result = 0;
        if (endian == Endian.little) {
          for (int i = 0; i < bytesNeeded; i++) {
            result |= (this[i] & 0xFF) << (i * 8);
          }
        } else {
          for (int i = 0; i < bytesNeeded; i++) {
            result = (result << 8) | (this[i] & 0xFF);
          }
        }
        return result;
    }
  }

  // 将 List<int> 转换为 int6
  int toInt6({Endian endian = Endian.little}) =>
      toInt(bitWidth: 6, endian: endian);

  // 将 List<int> 转换为 int16
  int toInt16({Endian endian = Endian.little}) =>
      toInt(bitWidth: 16, endian: endian);

  // 将 List<int> 转换为 int32
  int toInt32({Endian endian = Endian.little}) =>
      toInt(bitWidth: 32, endian: endian);

  // 将 List<int> 转换为 int64
  int toInt64({Endian endian = Endian.little}) =>
      toInt(bitWidth: 64, endian: endian);
}

extension ListStringExt<T> on List<T> {
  // 查询最后一个元素
  T? lastWhereOrNull(bool Function(T) test) {
    final newList = reversed.toList();
    return newList.firstWhereOrNull(test);
  }
}
