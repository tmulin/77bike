import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class ChineseCupertinoLocalizations implements CupertinoLocalizations {
  final LocalizationsDelegate _materialDelegate =
      GlobalMaterialLocalizations.delegate;

//  final LocalizationsDelegate _widgetsDelegate =
//      GlobalMaterialLocalizations.delegate;
  final Locale _locale =
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      const _ChineseCupertinoLocalizationsDelegate();

  MaterialLocalizations _materialLocalizations;

  Future init() async {
    _materialLocalizations = await _materialDelegate.load(_locale);
  }

  @override
  // TODO: implement alertDialogLabel
  String get alertDialogLabel => _materialLocalizations.alertDialogLabel;

  @override
  // TODO: implement anteMeridiemAbbreviation
  String get anteMeridiemAbbreviation =>
      _materialLocalizations.anteMeridiemAbbreviation;

  @override
  // TODO: implement copyButtonLabel
  String get copyButtonLabel => _materialLocalizations.copyButtonLabel;

  @override
  // TODO: implement cutButtonLabel
  String get cutButtonLabel => _materialLocalizations.cutButtonLabel;

  @override
  // TODO: implement datePickerDateOrder
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.ymd;

  @override
  // TODO: implement datePickerDateTimeOrder
  DatePickerDateTimeOrder get datePickerDateTimeOrder =>
      DatePickerDateTimeOrder.date_dayPeriod_time;

  @override
  String datePickerDayOfMonth(int dayIndex) {
    // TODO: implement datePickerDayOfMonth
    return "${dayIndex}";
  }

  @override
  String datePickerHour(int hour) {
    // TODO: implement datePickerHour
    return hour.toString().padLeft(2, '0');
  }

  @override
  String datePickerHourSemanticsLabel(int hour) {
    // TODO: implement datePickerHourSemanticsLabel
    return "${hour}时";
  }

  @override
  String datePickerMediumDate(DateTime date) {
    // TODO: implement datePickerMediumDate
    return _materialLocalizations.formatMediumDate(date);
  }

  @override
  String datePickerMinute(int minute) {
    // TODO: implement datePickerMinute
    return minute.toString().padLeft(2, '0');
  }

  @override
  String datePickerMinuteSemanticsLabel(int minute) {
    // TODO: implement datePickerMinuteSemanticsLabel
    return "${minute}分";
  }

  @override
  String datePickerMonth(int monthIndex) {
    // TODO: implement datePickerMonth
    return "${monthIndex}";
  }

  @override
  String datePickerYear(int yearIndex) {
    // TODO: implement datePickerYear
    return "${yearIndex}";
  }

  @override
  // TODO: implement pasteButtonLabel
  String get pasteButtonLabel => _materialLocalizations.pasteButtonLabel;

  @override
  // TODO: implement postMeridiemAbbreviation
  String get postMeridiemAbbreviation =>
      _materialLocalizations.postMeridiemAbbreviation;

  @override
  // TODO: implement selectAllButtonLabel
  String get selectAllButtonLabel =>
      _materialLocalizations.selectAllButtonLabel;

  @override
  String timerPickerHour(int hour) {
    // TODO: implement timerPickerHour
    return hour.toString().padLeft(2, '0');
  }

  @override
  String timerPickerHourLabel(int hour) {
    // TODO: implement timerPickerHourLabel
    return hour.toString().padLeft(2, '0') + "时";
  }

  @override
  String timerPickerMinute(int minute) {
    // TODO: implement timerPickerMinute
    return minute.toString().padLeft(2, '0');
  }

  @override
  String timerPickerMinuteLabel(int minute) {
    // TODO: implement timerPickerMinuteLabel
    return minute.toString().padLeft(2, '0') + "分";
  }

  @override
  String timerPickerSecond(int second) {
    // TODO: implement timerPickerSecond
    return second.toString().padLeft(2, '0');
  }

  @override
  String timerPickerSecondLabel(int second) {
    // TODO: implement timerPickerSecondLabel
    return second.toString().padLeft(2, '0') + "秒";
  }

  @override
  // TODO: implement todayLabel
  String get todayLabel => "今天";

  static Future<CupertinoLocalizations> load(Locale locale) async {
    var localizations = ChineseCupertinoLocalizations();
    await localizations.init();
    return SynchronousFuture(localizations);
  }
}

class _ChineseCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _ChineseCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == "zh";
  }

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return ChineseCupertinoLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<CupertinoLocalizations> old) {
    return false;
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
