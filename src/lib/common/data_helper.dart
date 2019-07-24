import 'package:intl/intl.dart';

class DataHelper {
  static bool isIsNullOrWhiteSpaceString(String s) {
    if (s == null) return true;
    return s.trim().length == 0;
  }

  static bool isNullOrEmptyString(String s) {
    if (s == null) return true;
    return s.length == 0;
  }

  static String toDateTimeOffsetString(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    int minutes = duration.inMinutes;
    if (minutes < 1) {
      return "刚刚";
    }
    if (minutes < 60) {
      return "${minutes}分钟前";
    }
    if (duration.inDays < 1) {
      return "${duration.inHours}小时前";
    }
    if (duration.inDays < 30) {
      return "${duration.inDays}天前";
    }
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }
  static String toDateString(DateTime date) {
    if (date == null) return "";

    return DateFormat("yyyy-MM-dd").format(date);
  }

  static toTimeString(DateTime date, {bool noSeconds = false}) {
    if (date == null) return "";

    if (noSeconds)
      return DateFormat("HH:mm").format(date);
    else
      return DateFormat("HH:mm:ss").format(date);
  }

  static String toDateTimeString(DateTime date, {bool noSeconds = false}) {
    if (date == null) return "";

    if (noSeconds)
      return DateFormat("yyyy-MM-dd HH:mm").format(date);
    else
      return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
  }

  /// 转变为yyyyMMddHHmmss格式的数字
  static int toDateTimeNumber(DateTime date) {
    return int.tryParse(DateFormat("yyyyMMddHHmmss").format(date));
  }

  static final List<String> shortWeekdays = ["一", "二", "三", "四", "五", "六", "日"];
  static final List<String> longWeekdays = [
    "星期一",
    "星期二",
    "星期三",
    "星期四",
    "星期五",
    "星期六",
    "星期日"
  ];

  static String toLongWeekDay(DateTime date) {
    return longWeekdays[date.weekday - 1];
  }

  static String toShortWeekDay(DateTime date) {
    return shortWeekdays[date.weekday - 1];
  }
}
