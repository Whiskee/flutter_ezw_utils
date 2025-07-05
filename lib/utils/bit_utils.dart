import 'dart:developer' as developer;
import 'dart:typed_data';

/// 比特位操作工具类
/// 提供完整的字节和比特位操作功能
class BitUtils {
  /// 将8个布尔值组装成一个字节
  ///
  /// [bits] 8个布尔值的列表，从左到右对应字节的高位到低位
  /// 返回组装后的字节值 (0-255)
  ///
  /// 示例:
  /// ```dart
  /// List<bool> bits = [true, false, true, false, true, false, true, false];
  /// int byte = BitUtils.assembleBitsToByte(bits);
  /// print(byte); // 输出: 170 (10101010)
  /// ```
  static int assembleBitsToByte(List<bool> bits) {
    if (bits.length != 8) {
      developer.log(
          'Error: Must provide exactly 8 boolean values, current count: ${bits.length}',
          name: 'BitUtils');
      return 0;
    }

    int result = 0;
    for (int i = 0; i < 8; i++) {
      if (bits[i]) {
        result |= (1 << (7 - i)); // 从左到右填充，最高位先填充
      }
    }
    return result;
  }

  /// 将1个字节分解为8个布尔值
  ///
  /// [byte] 字节值 (0-255)
  /// 返回8个布尔值的列表，从左到右对应字节的高位到低位
  ///
  /// 示例:
  /// ```dart
  /// int byte = 170; // 10101010
  /// List<bool> bits = BitUtils.disassembleByteToBits(byte);
  /// print(bits); // 输出: [true, false, true, false, true, false, true, false]
  /// ```
  static List<bool> disassembleByteToBits(int byte) {
    if (byte < 0 || byte > 255) {
      developer.log(
          'Error: Byte value must be in range 0-255, current value: $byte',
          name: 'BitUtils');
      return List.filled(8, false);
    }

    List<bool> bits = List.filled(8, false);
    for (int i = 0; i < 8; i++) {
      bits[i] = (byte & (1 << (7 - i))) != 0;
    }
    return bits;
  }

  /// 设置字节中指定位置的比特位
  ///
  /// [byte] 原始字节值
  /// [position] 位置 (0-7，0为最高位，7为最低位)
  /// [value] 要设置的值 (true为1，false为0)
  /// 返回修改后的字节值
  ///
  /// 示例:
  /// ```dart
  /// int byte = 0; // 00000000
  /// int newByte = BitUtils.setBit(byte, 0, true); // 设置最高位
  /// print(newByte); // 输出: 128 (10000000)
  /// ```
  static int setBit(int byte, int position, bool value) {
    if (position < 0 || position > 7) {
      developer.log(
          'Error: Position must be in range 0-7, current value: $position',
          name: 'BitUtils');
      return byte;
    }
    if (byte < 0 || byte > 255) {
      developer.log(
          'Error: Byte value must be in range 0-255, current value: $byte',
          name: 'BitUtils');
      return byte;
    }

    if (value) {
      return byte | (1 << (7 - position));
    } else {
      return byte & ~(1 << (7 - position));
    }
  }

  /// 获取字节中指定位置的比特位
  ///
  /// [byte] 字节值
  /// [position] 位置 (0-7，0为最高位，7为最低位)
  /// 返回该位置的布尔值
  ///
  /// 示例:
  /// ```dart
  /// int byte = 170; // 10101010
  /// bool bit = BitUtils.getBit(byte, 0); // 获取最高位
  /// print(bit); // 输出: true
  /// ```
  static bool getBit(int byte, int position) {
    if (position < 0 || position > 7) {
      developer.log(
          'Error: Position must be in range 0-7, current value: $position',
          name: 'BitUtils');
      return false;
    }
    if (byte < 0 || byte > 255) {
      developer.log(
          'Error: Byte value must be in range 0-255, current value: $byte',
          name: 'BitUtils');
      return false;
    }

    return (byte & (1 << (7 - position))) != 0;
  }

  /// 将字节转换为二进制字符串
  ///
  /// [byte] 字节值
  /// [withSpaces] 是否在每4位之间添加空格
  /// 返回二进制字符串表示
  ///
  /// 示例:
  /// ```dart
  /// int byte = 170;
  /// String binary = BitUtils.byteToBinaryString(byte);
  /// print(binary); // 输出: "10101010"
  ///
  /// String binaryWithSpaces = BitUtils.byteToBinaryString(byte, withSpaces: true);
  /// print(binaryWithSpaces); // 输出: "1010 1010"
  /// ```
  static String byteToBinaryString(int byte, {bool withSpaces = false}) {
    if (byte < 0 || byte > 255) {
      developer.log(
          'Error: Byte value must be in range 0-255, current value: $byte',
          name: 'BitUtils');
      return '00000000';
    }

    String binary = byte.toRadixString(2).padLeft(8, '0');
    if (withSpaces) {
      return '${binary.substring(0, 4)} ${binary.substring(4)}';
    }
    return binary;
  }

  /// 将二进制字符串转换为字节
  ///
  /// [binaryString] 二进制字符串 (8位)
  /// 返回字节值
  ///
  /// 示例:
  /// ```dart
  /// String binary = "10101010";
  /// int byte = BitUtils.binaryStringToByte(binary);
  /// print(byte); // 输出: 170
  /// ```
  static int binaryStringToByte(String binaryString) {
    // 移除空格
    String cleanBinary = binaryString.replaceAll(' ', '');

    if (cleanBinary.length != 8) {
      developer.log(
          'Error: Binary string must be exactly 8 bits, current length: ${cleanBinary.length}',
          name: 'BitUtils');
      return 0;
    }

    // 验证是否只包含0和1
    if (!RegExp(r'^[01]+$').hasMatch(cleanBinary)) {
      developer.log('Error: Binary string can only contain 0 and 1',
          name: 'BitUtils');
      return 0;
    }

    return int.parse(cleanBinary, radix: 2);
  }

  /// 创建自定义字节的便捷方法
  ///
  /// [bit7] 最高位 (第7位)
  /// [bit6] 第6位
  /// [bit5] 第5位
  /// [bit4] 第4位
  /// [bit3] 第3位
  /// [bit2] 第2位
  /// [bit1] 第1位
  /// [bit0] 最低位 (第0位)
  /// 返回组装后的字节值
  ///
  /// 示例:
  /// ```dart
  /// int byte = BitUtils.createCustomByte(
  ///   bit7: true,   // 最高位
  ///   bit6: false,
  ///   bit5: true,
  ///   bit4: false,
  ///   bit3: true,
  ///   bit2: false,
  ///   bit1: true,
  ///   bit0: false,  // 最低位
  /// );
  /// print(byte); // 输出: 170 (10101010)
  /// ```
  static int createCustomByte({
    bool bit7 = false,
    bool bit6 = false,
    bool bit5 = false,
    bool bit4 = false,
    bool bit3 = false,
    bool bit2 = false,
    bool bit1 = false,
    bool bit0 = false,
  }) {
    return assembleBitsToByte([bit7, bit6, bit5, bit4, bit3, bit2, bit1, bit0]);
  }

  /// 将字节列表转换为比特位列表
  ///
  /// [bytes] 字节列表
  /// 返回比特位列表，每个字节对应8个布尔值
  ///
  /// 示例:
  /// ```dart
  /// List<int> bytes = [170, 85]; // [10101010, 01010101]
  /// List<bool> bits = BitUtils.bytesToBits(bytes);
  /// print(bits.length); // 输出: 16
  /// ```
  static List<bool> bytesToBits(List<int> bytes) {
    List<bool> allBits = [];
    for (int byte in bytes) {
      allBits.addAll(disassembleByteToBits(byte));
    }
    return allBits;
  }

  /// 将比特位列表转换为字节列表
  ///
  /// [bits] 比特位列表
  /// 返回字节列表，每8个布尔值对应1个字节
  ///
  /// 示例:
  /// ```dart
  /// List<bool> bits = [true, false, true, false, true, false, true, false,
  ///                    false, true, false, true, false, true, false, true];
  /// List<int> bytes = BitUtils.bitsToBytes(bits);
  /// print(bytes); // 输出: [170, 85]
  /// ```
  static List<int> bitsToBytes(List<bool> bits) {
    if (bits.length % 8 != 0) {
      developer.log(
          'Error: Number of bits must be multiple of 8, current count: ${bits.length}',
          name: 'BitUtils');
      return [];
    }

    List<int> bytes = [];
    for (int i = 0; i < bits.length; i += 8) {
      List<bool> byteBits = bits.sublist(i, i + 8);
      bytes.add(assembleBitsToByte(byteBits));
    }
    return bytes;
  }

  /// 将字节列表转换为Uint8List
  ///
  /// [bytes] 字节列表
  /// 返回Uint8List
  ///
  /// 示例:
  /// ```dart
  /// List<int> bytes = [170, 85, 255];
  /// Uint8List uint8List = BitUtils.bytesToUint8List(bytes);
  /// ```
  static Uint8List bytesToUint8List(List<int> bytes) {
    return Uint8List.fromList(bytes);
  }

  /// 将Uint8List转换为字节列表
  ///
  /// [uint8List] Uint8List
  /// 返回字节列表
  ///
  /// 示例:
  /// ```dart
  /// Uint8List uint8List = Uint8List.fromList([170, 85, 255]);
  /// List<int> bytes = BitUtils.uint8ListToBytes(uint8List);
  /// ```
  static List<int> uint8ListToBytes(Uint8List uint8List) {
    return uint8List.toList();
  }

  /// 检查字节中指定位置是否为1
  ///
  /// [byte] 字节值
  /// [position] 位置 (0-7)
  /// 返回是否为1
  ///
  /// 示例:
  /// ```dart
  /// int byte = 170; // 10101010
  /// bool isSet = BitUtils.isBitSet(byte, 0); // 检查最高位
  /// print(isSet); // 输出: true
  /// ```
  static bool isBitSet(int byte, int position) {
    return getBit(byte, position);
  }

  /// 翻转字节中指定位置的比特位
  ///
  /// [byte] 原始字节值
  /// [position] 位置 (0-7)
  /// 返回翻转后的字节值
  ///
  /// 示例:
  /// ```dart
  /// int byte = 0; // 00000000
  /// int flipped = BitUtils.flipBit(byte, 0); // 翻转最高位
  /// print(flipped); // 输出: 128 (10000000)
  /// ```
  static int flipBit(int byte, int position) {
    if (position < 0 || position > 7) {
      developer.log(
          'Error: Position must be in range 0-7, current value: $position',
          name: 'BitUtils');
      return byte;
    }
    if (byte < 0 || byte > 255) {
      developer.log(
          'Error: Byte value must be in range 0-255, current value: $byte',
          name: 'BitUtils');
      return byte;
    }

    return byte ^ (1 << (7 - position));
  }

  /// 计算字节中1的个数
  ///
  /// [byte] 字节值
  /// 返回1的个数
  ///
  /// 示例:
  /// ```dart
  /// int byte = 170; // 10101010
  /// int count = BitUtils.countOnes(byte);
  /// print(count); // 输出: 4
  /// ```
  static int countOnes(int byte) {
    if (byte < 0 || byte > 255) {
      developer.log(
          'Error: Byte value must be in range 0-255, current value: $byte',
          name: 'BitUtils');
      return 0;
    }

    int count = 0;
    for (int i = 0; i < 8; i++) {
      if ((byte & (1 << i)) != 0) {
        count++;
      }
    }
    return count;
  }

  /// 计算字节中0的个数
  ///
  /// [byte] 字节值
  /// 返回0的个数
  ///
  /// 示例:
  /// ```dart
  /// int byte = 170; // 10101010
  /// int count = BitUtils.countZeros(byte);
  /// print(count); // 输出: 4
  /// ```
  static int countZeros(int byte) {
    return 8 - countOnes(byte);
  }

  /// 获取字节中最高位的位置
  ///
  /// [byte] 字节值
  /// 返回最高位的位置 (0-7)，如果没有1则返回-1
  ///
  /// 示例:
  /// ```dart
  /// int byte = 170; // 10101010
  /// int position = BitUtils.getHighestBitPosition(byte);
  /// print(position); // 输出: 0 (最高位)
  /// ```
  static int getHighestBitPosition(int byte) {
    if (byte < 0 || byte > 255) {
      developer.log(
          'Error: Byte value must be in range 0-255, current value: $byte',
          name: 'BitUtils');
      return -1;
    }

    if (byte == 0) return -1;

    for (int i = 7; i >= 0; i--) {
      if ((byte & (1 << (7 - i))) != 0) {
        return i;
      }
    }
    return -1;
  }

  /// 获取字节中最低位的位置
  ///
  /// [byte] 字节值
  /// 返回最低位的位置 (0-7)，如果没有1则返回-1
  ///
  /// 示例:
  /// ```dart
  /// int byte = 170; // 10101010
  /// int position = BitUtils.getLowestBitPosition(byte);
  /// print(position); // 输出: 1 (最低位)
  /// ```
  static int getLowestBitPosition(int byte) {
    if (byte < 0 || byte > 255) {
      developer.log(
          'Error: Byte value must be in range 0-255, current value: $byte',
          name: 'BitUtils');
      return -1;
    }

    if (byte == 0) return -1;

    for (int i = 0; i < 8; i++) {
      if ((byte & (1 << (7 - i))) != 0) {
        return i;
      }
    }
    return -1;
  }

  /// 将字节左移指定位数
  ///
  /// [byte] 原始字节值
  /// [shift] 左移位数 (0-7)
  /// 返回左移后的字节值
  ///
  /// 示例:
  /// ```dart
  /// int byte = 1; // 00000001
  /// int shifted = BitUtils.leftShift(byte, 3);
  /// print(shifted); // 输出: 8 (00001000)
  /// ```
  static int leftShift(int byte, int shift) {
    if (shift < 0 || shift > 7) {
      developer.log(
          'Error: Left shift amount must be in range 0-7, current value: $shift',
          name: 'BitUtils');
      return byte;
    }
    if (byte < 0 || byte > 255) {
      developer.log(
          'Error: Byte value must be in range 0-255, current value: $byte',
          name: 'BitUtils');
      return byte;
    }

    return (byte << shift) & 0xFF;
  }

  /// 将字节右移指定位数
  ///
  /// [byte] 原始字节值
  /// [shift] 右移位数 (0-7)
  /// 返回右移后的字节值
  ///
  /// 示例:
  /// ```dart
  /// int byte = 8; // 00001000
  /// int shifted = BitUtils.rightShift(byte, 3);
  /// print(shifted); // 输出: 1 (00000001)
  /// ```
  static int rightShift(int byte, int shift) {
    if (shift < 0 || shift > 7) {
      developer.log(
          'Error: Right shift amount must be in range 0-7, current value: $shift',
          name: 'BitUtils');
      return byte;
    }
    if (byte < 0 || byte > 255) {
      developer.log(
          'Error: Byte value must be in range 0-255, current value: $byte',
          name: 'BitUtils');
      return byte;
    }

    return (byte >> shift) & 0xFF;
  }

  /// 将字节循环左移指定位数
  ///
  /// [byte] 原始字节值
  /// [shift] 循环左移位数 (0-7)
  /// 返回循环左移后的字节值
  ///
  /// 示例:
  /// ```dart
  /// int byte = 170; // 10101010
  /// int rotated = BitUtils.rotateLeft(byte, 2);
  /// print(rotated); // 输出: 170 (10101010)
  /// ```
  static int rotateLeft(int byte, int shift) {
    if (shift < 0 || shift > 7) {
      developer.log(
          'Error: Rotate left amount must be in range 0-7, current value: $shift',
          name: 'BitUtils');
      return byte;
    }
    if (byte < 0 || byte > 255) {
      developer.log(
          'Error: Byte value must be in range 0-255, current value: $byte',
          name: 'BitUtils');
      return byte;
    }

    shift = shift % 8;
    return ((byte << shift) | (byte >> (8 - shift))) & 0xFF;
  }

  /// 将字节循环右移指定位数
  ///
  /// [byte] 原始字节值
  /// [shift] 循环右移位数 (0-7)
  /// 返回循环右移后的字节值
  ///
  /// 示例:
  /// ```dart
  /// int byte = 170; // 10101010
  /// int rotated = BitUtils.rotateRight(byte, 2);
  /// print(rotated); // 输出: 170 (10101010)
  /// ```
  static int rotateRight(int byte, int shift) {
    if (shift < 0 || shift > 7) {
      developer.log(
          'Error: Rotate right amount must be in range 0-7, current value: $shift',
          name: 'BitUtils');
      return byte;
    }
    if (byte < 0 || byte > 255) {
      developer.log(
          'Error: Byte value must be in range 0-255, current value: $byte',
          name: 'BitUtils');
      return byte;
    }

    shift = shift % 8;
    return ((byte >> shift) | (byte << (8 - shift))) & 0xFF;
  }
}
