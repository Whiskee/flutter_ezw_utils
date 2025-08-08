class VersionUtil {
  VersionUtil._();

  /// 版本比较：返回 -1(a<b)、0(a==b)、1(a>b)
  /// 规则：按 `.` 分段逐段数值比较；
  /// - 段数不等时用 0 补齐（至少比较到四段，以满足 0.0.0.0 要求）
  /// - 示例：1.1.0 < 1.1.1；1.1.2 > 1.1.0；1.1.2 > 1.1.1.x（x为任意正数）
  static int compareVersion(String a, String b) {
    String na = _normalize(a);
    String nb = _normalize(b);

    // 至少比较四段
    const int minSegments = 4;
    final List<int> pa = _toSegments(na, minSegments);
    final List<int> pb = _toSegments(nb, minSegments);

    final int len = pa.length > pb.length ? pa.length : pb.length;
    for (int i = 0; i < len; i++) {
      final int va = i < pa.length ? pa[i] : 0;
      final int vb = i < pb.length ? pb[i] : 0;
      if (va == vb) continue;
      return va < vb ? -1 : 1;
    }
    return 0;
  }

  static String _normalize(String input) {
    String s = input.trim();
    if (s.startsWith('v') || s.startsWith('V')) {
      s = s.substring(1);
    }
    // 忽略 -beta、+build 等后缀，仅比较主版本段
    final int dash = s.indexOf('-');
    final int plus = s.indexOf('+');
    int cut = -1;
    if (dash >= 0 && plus >= 0) {
      cut = dash < plus ? dash : plus;
    } else if (dash >= 0) {
      cut = dash;
    } else if (plus >= 0) {
      cut = plus;
    }
    if (cut >= 0) s = s.substring(0, cut);
    return s;
  }

  static List<int> _toSegments(String version, int minSegments) {
    final List<String> parts = version.split('.');
    final int targetLen =
        parts.length < minSegments ? minSegments : parts.length;
    final List<int> nums = <int>[];
    for (int i = 0; i < targetLen; i++) {
      if (i < parts.length) {
        final match = RegExp(r'^\d+').firstMatch(parts[i].trim());
        nums.add(match != null ? int.parse(match.group(0)!) : 0);
      } else {
        nums.add(0);
      }
    }
    return nums;
  }
}
