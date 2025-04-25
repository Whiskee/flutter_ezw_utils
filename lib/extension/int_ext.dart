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

extension WidgetIntExt on int {
  Widget get widthBox => SizedBox(width: toDouble());
  Widget get heightBox => SizedBox(height: toDouble());
}
