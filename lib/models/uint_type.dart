/// 字节类型
enum UintType {
  uint8, // 8位-1个字节
  uint16, // 16位-2个字节
  uint32, // 32位-4个字节
  uint64, // 64位-8个字节
}

extension UintTypeExt on UintType {
  int get byteLength {
    switch (this) {
      case UintType.uint8:
        return 1;
      case UintType.uint16:
        return 2;
      case UintType.uint32:
        return 4;
      case UintType.uint64:
        return 8;
    }
  }
}
