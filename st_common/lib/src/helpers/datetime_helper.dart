import 'package:intl/intl.dart';

enum DateTimeFormatEnum {
  WEEKDAY_DAY_MONTH_YEAR,
  DAY_MONTH_YEAR,
  MONTH_YEAR,
  ABBR_DAY_MONTH_YEAR,
  ABBR_WEEKDAY_DAY_MONTH,
  ABBR_MONTH_DAY,
  ABBR_MONTH_DAY_YEAR,
}

//Friday, 10 of July of 2019 - "es" -> viernes, 10 de Julio de 2019
final weekdayDayMonthYear = new DateFormat.yMMMMEEEEd("es");

//-> July 10, 1996 - "es"-> 10 de Julio de 2019
final dayMonthYear = new DateFormat.yMMMMd("es");

//-> Enero 2020
final monthYear = new DateFormat('MMMM y', "es");

//vie., 27 dic.
final abbrWeekdayDayMonth = new DateFormat.MMMEd("es");

//-> Nov 12, 2020 - "es"-> 13 nov, 2019
final abbrDayMonthYear = new DateFormat.yMMMd("es");

//-> Ene. 27
final abbrMonthDay = new DateFormat('MMM d', "es");

//-> Ene. 27, 20
final abbrMonthDayYear = new DateFormat('MMM d, y', "es");

//19:08
final hour = new DateFormat.Hm();

//2020-07-14T19:04:26.626Z
//2020-05-26T20:00-04:00[America/La_Paz]
DateTime stringToDateTime(String date) {
  if (date == null || date.isEmpty) return null;
  final String _date =
      date.indexOf('[') != -1 ? date.substring(0, date.indexOf('[')) : date;
  return DateTime.parse(_date).toLocal();
}

//Date => 2019-11-18T20:45:54.182Z
String dateTimeToZonedDateTime(DateTime date) {
  if (date == null) return null;
  final formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  return (formatter.format(date));
}

String stringToFormatDateTime(
  String dateTimeStr, [
  DateTimeFormatEnum format,
  bool withHour,
  String hourSeparateBy,
]) {
  final date = stringToDateTime(dateTimeStr);
  
  if(date == null) return null; 

  return date.toStringFormat(format, withHour, hourSeparateBy);
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
        && this.day == other.day;
  }

  bool isLastDate(DateTime other) {
    return this.year == other.year && this.month == other.month
        && this.day == other.day;
  }

  String get hourFormat{
    if (this == null) return null;

    return hour.format(this);
  }

  String toStringFormat([
    DateTimeFormatEnum format = DateTimeFormatEnum.ABBR_MONTH_DAY_YEAR,
    bool withHour,
    String hourSeparateBy,
  ]) {
    if (this == null) return null;
    
    String _date;
    
    switch (format) {
      case DateTimeFormatEnum.WEEKDAY_DAY_MONTH_YEAR:
        _date = weekdayDayMonthYear.format(this);
        break;
      case DateTimeFormatEnum.DAY_MONTH_YEAR:
        _date = dayMonthYear.format(this);
        break;
      case DateTimeFormatEnum.MONTH_YEAR:
        _date = monthYear.format(this);
        _date = _date.substring(0, 1).toUpperCase() + _date.substring(1, _date.length);
        break;
      case DateTimeFormatEnum.ABBR_DAY_MONTH_YEAR:
        _date = abbrDayMonthYear.format(this);
        break;
      case DateTimeFormatEnum.ABBR_WEEKDAY_DAY_MONTH:
        _date = abbrWeekdayDayMonth.format(this);
        break;
      case DateTimeFormatEnum.ABBR_MONTH_DAY:
        _date = abbrMonthDay.format(this);
        _date = _date.substring(0, 1).toUpperCase() + _date.substring(1, _date.length);
        break;
      case DateTimeFormatEnum.ABBR_MONTH_DAY_YEAR:
      default:
        _date = abbrMonthDayYear.format(this);
        _date = _date.substring(0, 1).toUpperCase() + _date.substring(1, _date.length);
        break;
    }

    if (withHour != null && withHour) {
      _date = '$_date ${hourSeparateBy ?? ','} ${hour.format(this)}';
    }
    
    return '$_date';
  }
}

extension DurationToHours on Duration {
  String get inDaysString {
    int _days;
    int _hours;
    int _minutes;
    String _duration = '';

    if(this.inDays > 0){
      _days = this.inDays;
      _hours = this.inHours - (24 * _days);
      _minutes = this.inMinutes - (60 * this.inHours);
    } else if (this.inHours > 0) {
      _hours = this.inHours;
      _minutes = this.inMinutes - (60 * _hours);
    } else if (this.inMinutes > 0) {
      _minutes = this.inMinutes;
    }

    if(_days != null && _days != 0){
      _duration = '${_days}d ';
    }

    if(_hours != null && _hours != 0){
      _duration = '$_duration${_hours}h ';
    }

    if(_minutes != null && _minutes != 0){
      _duration = '$_duration${_minutes}min';
    }
    return _duration;
  }
}