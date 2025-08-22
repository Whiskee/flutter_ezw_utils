import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

extension StringExt on String {
  /// 字符串转Uint8List
  Uint8List toUint8List() => utf8.encode(this);

  /// 字符串转Map
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

  /// 将MAC地址转换为Uint8List
  Uint8List macToBytes({bool? isLittleEndian}) {
    // 移除所有可能的分隔符（冒号、连字符、空格等）
    String cleanMac = replaceAll(RegExp(r'[:\- ]'), '').toUpperCase();
    // 验证MAC地址格式
    if (!RegExp(r'^[0-9A-F]{12}$').hasMatch(cleanMac)) {
      return Uint8List(0);
    }
    // 将每两个字符转换成一个字节
    List<int> bytes = [];
    for (int i = 0; i < cleanMac.length; i += 2) {
      String byteStr = cleanMac.substring(i, i + 2);
      bytes.add(int.parse(byteStr, radix: 16));
    }
    // 判断当前MAC地址的字节序
    // 如果第一个字节大于最后一个字节，说明是大端序
    bool isCurrentBigEndian = bytes.first > bytes.last;
    // 根据isLittleEndian参数和当前字节序决定是否需要转换
    if (isLittleEndian != null && isLittleEndian != !isCurrentBigEndian) {
      bytes = bytes.reversed.toList();
    }
    return Uint8List.fromList(bytes);
  }
}

extension StringNullExt on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
