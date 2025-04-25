extension ListIntExt on List<int> {
  // 将 4 字节 List<int> 转换为 int
  int fourBytesToInt() =>
      (this[0] << 24) | (this[1] << 16) | (this[2] << 8) | this[3];
}
