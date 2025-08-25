// ignore_for_file: depend_on_referenced_packages, constant_identifier_names

import 'package:flutter_ezw_utils/flutter_ezw_index.dart';
import 'package:intl/intl.dart';

/// Date utility class
class DateUtil {
  DateUtil._();

  /// Common date formats
  static const String formatYYYYMMDD = 'yyyyMMdd';
  static const String formatYYYY_MM_DD = 'yyyy-MM-dd';
  static const String formatYYYY_MM_DD_HH_MM = 'yyyy-MM-dd HH:mm';
  static const String formatYYYY_MM_DD_HH_MM_SS = 'yyyy-MM-dd HH:mm:ss';
  static const String formatMM_DD = 'MM-dd';
  static const String formatHH_MM = 'HH:mm';
  static const String formatHH_MM_SS = 'HH:mm:ss';
  static const String formatYYYY_MM_DD_CN = 'yyyy年MM月dd日';
  static const String formatMM_DD_CN = 'MM月dd日';

  /// 根据格式字符串获取当前日期的字符串表示
  ///
  /// [format] 日期格式，如 'yyyyMMdd', 'yyyy-MM-dd' 等
  /// 返回格式化后的日期字符串
  static String getCurrentDateString([String format = formatYYYY_MM_DD]) {
    final now = DateTime.now();
    return DateFormat(format).format(now);
  }

  /// 根据格式字符串获取指定日期的字符串表示
  ///
  /// [dateTime] 要格式化的日期时间
  /// [format] 日期格式，如 'yyyyMMdd', 'yyyy-MM-dd' 等
  /// 返回格式化后的日期字符串
  static String getDateString(DateTime dateTime,
      [String format = formatYYYY_MM_DD]) {
    return DateFormat(format).format(dateTime);
  }

  /// 将字符串转换为DateTime对象
  ///
  /// [dateString] 日期字符串
  /// [format] 日期格式，如 'yyyyMMdd', 'yyyy-MM-dd' 等
  /// 返回DateTime对象，如果解析失败返回null
  static DateTime? parseDateString(String dateString,
      [String format = formatYYYY_MM_DD]) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// 将字符串转换为DateTime对象（自动尝试多种格式）
  ///
  /// [dateString] 日期字符串
  /// 返回DateTime对象，如果解析失败返回null
  static DateTime? parseDateStringAuto(String dateString) {
    final formats = [
      formatYYYYMMDD,
      formatYYYY_MM_DD,
      formatYYYY_MM_DD_HH_MM,
      formatYYYY_MM_DD_HH_MM_SS,
      formatYYYY_MM_DD_CN,
    ];

    for (final format in formats) {
      final result = parseDateString(dateString, format);
      if (result != null) {
        return result;
      }
    }

    return null;
  }

  /// 获取指定格式的当前时间字符串
  ///
  /// [format] 时间格式，如 'HH:mm', 'HH:mm:ss' 等
  /// 返回格式化后的时间字符串
  static String getCurrentTimeString([String format = formatHH_MM]) {
    final now = DateTime.now();
    return DateFormat(format).format(now);
  }

  /// 获取指定格式的指定时间字符串
  ///
  /// [dateTime] 要格式化的日期时间
  /// [format] 时间格式，如 'HH:mm', 'HH:mm:ss' 等
  /// 返回格式化后的时间字符串
  static String getTimeString(
    DateTime dateTime, [
    String format = formatHH_MM,
  ]) =>
      DateFormat(format).format(dateTime);

  /// 获取相对时间描述（如：刚刚、5分钟前、1小时前等）
  ///
  /// [dateTime] 要计算相对时间的日期时间
  /// 返回相对时间描述字符串
  static String getRelativeTimeString(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago'.tr;
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago'.tr;
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago'.tr;
    } else if (difference.inSeconds > 30) {
      return '${difference.inSeconds} seconds ago'.tr;
    } else {
      return 'Just now'.tr;
    }
  }

  /// 获取友好的日期显示（如：今天、昨天、前天等）
  ///
  /// [dateTime] 要显示的日期时间
  /// [format] 非今天/昨天/前天的日期格式
  /// 返回友好的日期显示字符串
  static String getFriendlyDateString(
    DateTime dateTime, [
    String format = formatMM_DD,
  ]) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    if (targetDate == today) {
      return 'Today'.tr;
    } else if (targetDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday'.tr;
    } else if (targetDate == today.subtract(const Duration(days: 2))) {
      return 'Day before yesterday'.tr;
    } else if (targetDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow'.tr;
    } else if (targetDate == today.add(const Duration(days: 2))) {
      return 'Day after tomorrow'.tr;
    } else {
      return getDateString(dateTime, format);
    }
  }

  /// 获取星期几
  ///
  /// [dateTime] 日期时间
  /// [isShort] 是否使用短格式（如：周一 vs 星期一）
  /// 返回星期几字符串
  static String getWeekdayString(DateTime dateTime, [bool isShort = true]) {
    final weekdays = isShort
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday'
          ];

    return weekdays[dateTime.weekday - 1];
  }

  /// 获取当前日期是星期几
  ///
  /// [isShort] 是否使用短格式
  /// 返回星期几字符串
  static String getCurrentWeekdayString([bool isShort = true]) {
    return getWeekdayString(DateTime.now(), isShort);
  }

  /// 检查是否为同一天
  ///
  /// [date1] 第一个日期
  /// [date2] 第二个日期
  /// 返回是否为同一天
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// 检查是否为今天
  ///
  /// [dateTime] 要检查的日期时间
  /// 返回是否为今天
  static bool isToday(DateTime dateTime) => isSameDay(dateTime, DateTime.now());

  /// 检查是否为昨天
  ///
  /// [dateTime] 要检查的日期时间
  /// 返回是否为昨天
  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(dateTime, yesterday);
  }

  /// 获取两个日期之间的天数差
  ///
  /// [date1] 第一个日期
  /// [date2] 第二个日期
  /// 返回天数差
  static int getDaysDifference(DateTime date1, DateTime date2) {
    final d1 = DateTime(date1.year, date1.month, date1.day);
    final d2 = DateTime(date2.year, date2.month, date2.day);
    return d2.difference(d1).inDays;
  }

  /// 获取指定日期是当月的第几天
  ///
  /// [dateTime] 日期时间
  /// 返回当月的第几天
  static int getDayOfMonth(DateTime dateTime) => dateTime.day;

  /// 获取指定日期是当年的第几天
  ///
  /// [dateTime] 日期时间
  /// 返回当年的第几天
  static int getDayOfYear(DateTime dateTime) {
    final startOfYear = DateTime(dateTime.year, 1, 1);
    return dateTime.difference(startOfYear).inDays + 1;
  }

  /// 获取指定日期所在月份的天数
  ///
  /// [dateTime] 日期时间
  /// 返回该月的天数
  static int getDaysInMonth(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month + 1, 0).day;

  /// 获取指定日期所在月份的第一天
  ///
  /// [dateTime] 日期时间
  /// 返回该月第一天的DateTime
  static DateTime getFirstDayOfMonth(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, 1);

  /// 获取指定日期所在月份的最后一天
  ///
  /// [dateTime] 日期时间
  /// 返回该月最后一天的DateTime
  static DateTime getLastDayOfMonth(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month + 1, 0);

  /// 获取指定日期所在周的第一天（周一）
  ///
  /// [dateTime] 日期时间
  /// 返回该周第一天的DateTime
  static DateTime getFirstDayOfWeek(DateTime dateTime) {
    final weekday = dateTime.weekday;
    return dateTime.subtract(Duration(days: weekday - 1));
  }

  /// 获取指定日期所在周的最后一天（周日）
  ///
  /// [dateTime] 日期时间
  /// 返回该周最后一天的DateTime
  static DateTime getLastDayOfWeek(DateTime dateTime) {
    final weekday = dateTime.weekday;
    return dateTime.add(Duration(days: 7 - weekday));
  }

  /// 格式化时间戳
  ///
  /// [timestamp] 时间戳（毫秒）
  /// [format] 日期格式
  /// 返回格式化后的日期字符串
  static String formatTimestamp(int timestamp,
      [String format = formatYYYY_MM_DD_HH_MM_SS]) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return getDateString(dateTime, format);
  }

  /// 获取当前时间戳（毫秒）
  ///
  /// 返回当前时间戳
  static int getCurrentTimestamp() => DateTime.now().millisecondsSinceEpoch;

  /// 获取当前时间戳（秒）
  ///
  /// 返回当前时间戳（秒）
  static int getCurrentTimestampSeconds() =>
      DateTime.now().millisecondsSinceEpoch ~/ 1000;

  /// 检查是否为闰年
  ///
  /// [year] 年份
  /// 返回是否为闰年
  static bool isLeapYear(int year) =>
      (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

  /// 获取年龄
  ///
  /// [birthDate] 出生日期
  /// 返回年龄
  static int getAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// 根据ISO获取一年总周数
  static int isoWeeksInYear(int year) {
    final jan1 = DateTime(year, 1, 1);
    final dec31 = DateTime(year, 12, 31);
    // 如果 1 月 1 日是星期四，或者 12 月 31 日是星期四 => 53 周
    return jan1.weekday == DateTime.thursday ||
            dec31.weekday == DateTime.thursday
        ? 53
        : 52;
  }

  /// 结合 ISO 周数规则来计算某个时间戳是该年的第几周
  static int getWeekNumber(int timestamp) {
    //  1、时间戳转时间格式
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    //  2、获取当前时间是一年的第几天
    final dayOfYear = int.parse(DateFormat("D").format(date));
    //  3、当前日期是星期几（星期一=1, 星期日=7）
    int weekday = date.weekday;
    //  4、ISO 8601 规定的周数计算公式：week = (dayOfYear - weekday + 10) ~/ 7
    int weekNumber = ((dayOfYear - weekday + 10) / 7).floor();
    return weekNumber;
  }

  /// 获取某个周数坐在年份的其实日期和结束日期
  IsoWeekRange? isoWeekRange(int year, int weekNumber) {
    //  1、获取当年最大周数
    final maxWeeks = isoWeeksInYear(year);
    //  2、
    if (weekNumber < 1 || weekNumber > maxWeeks) {
        return null;
    } 
    //  3、计算：
    //  - 第 1 周：包含 1 月 4 日的那一周
    final jan4 = DateTime(year, 1, 4);
    //  - 获取该周的周一（weekday: Mon=1..Sun=7）
    final mondayOfWeek1 = jan4.subtract(
      Duration(days: jan4.weekday - DateTime.monday),
    );
    // 目标周的起止
    final start = mondayOfWeek1.add(Duration(days: (weekNumber - 1) * 7));
    final end = start.add(const Duration(days: 6));
    return IsoWeekRange(start, end);
  }
}

/// ISO规则下，某个周数的范围
class IsoWeekRange {
  final DateTime start; // 周一（含）
  final DateTime end; // 周日（含）
  IsoWeekRange(this.start, this.end);
}
