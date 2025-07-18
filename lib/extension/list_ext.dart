import 'dart:typed_data';

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

  //  转字符串
  String encodeString() => String.fromCharCodes(this);

  // 将 4 字节 List<int> 转换为 int
  int fourBytesToInt() =>
      (this[0] << 24) | (this[1] << 16) | (this[2] << 8) | this[3];
}
