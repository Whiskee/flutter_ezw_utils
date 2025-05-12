import 'dart:typed_data';

extension Int16ListExt on Int16List {
  /// 将Int16List转换为十六进制字符串
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
}
