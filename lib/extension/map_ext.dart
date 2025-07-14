import 'dart:convert';
import 'dart:typed_data';

extension MapExt on Map<String, dynamic> {
  /// 将 Map 转换为 Uint8List
  ///
  /// 这个方法将 Map 转换为 JSON 字符串，然后编码为 UTF-8 字节数组
  Uint8List? toUint8List() {
    try {
      final jsonString = jsonEncode(this);
      return Uint8List.fromList(utf8.encode(jsonString));
    } catch (e) {
      return null;
    }
  }

  /// 安全地将 Map 转换为 Uint8List
  ///
  /// 如果转换失败，返回空的 Uint8List
  Uint8List? toUint8ListSafe() {
    try {
      final jsonString = jsonEncode(this);
      return Uint8List.fromList(utf8.encode(jsonString));
    } catch (e) {
      return null;
    }
  }
}
