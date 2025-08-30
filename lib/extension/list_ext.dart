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

  // 将 4 字节 List<int> 转换为 int
  int fourBytesToInt() =>
      (this[0] << 24) | (this[1] << 16) | (this[2] << 8) | this[3];
}

extension ListStringExt<T> on List<T> {
  // 查询最后一个元素
  T? lastWhereOrNull(bool Function(T) test) {
    final newList = reversed.toList();
    return newList.firstWhereOrNull(test);
  }
}
