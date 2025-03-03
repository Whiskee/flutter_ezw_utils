import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

extension StringExt on String {
  Map<String, dynamic> toMap() {
    try {
      return jsonDecode(this);
    } catch (e) {
      log("String - toMap: error = $e");
      return {};
    }
  }

  Uint8List hexStringToUint8List() {
    // 确保输入字符串长度为偶数，因为每两个十六进制字符表示一个字节
    if (length % 2 != 0) {
      throw ArgumentError("Invalid hex string length.");
    }
    // 创建一个Uint8List，其长度等于输入字符串长度的一半（因为每两个字符表示一个字节）
    final Uint8List result = Uint8List(length ~/ 2);
    // 遍历输入字符串，每两个字符一组进行转换
    for (int i = 0; i < length; i += 2) {
      // 提取两个字符，并将它们转换为整数（基数为16）
      final int byteValue = int.parse(substring(i, i + 2), radix: 16);
      // 将转换后的整数存储在Uint8List中
      result[i ~/ 2] = byteValue;
    }
    return result;
  }

  Uint8List encodeBase64() => base64Decode(this);
}

extension StringNullExt on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
