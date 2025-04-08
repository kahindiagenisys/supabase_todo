import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

extension DatetimeExtensions on DateTime {
  DateTime get startOfDay {
    return Jiffy.parseFromDateTime(this)
        .startOf(Unit.day)
        .subtract(milliseconds: kIsWeb ? 1 : 0)
        .dateTime;
  }

  DateTime get endOfDay {
    return Jiffy.parseFromDateTime(this)
        .endOf(Unit.day)
        .subtract(milliseconds: kIsWeb ? 1 : 0)
        .dateTime;
  }

  DateTime get startOfNextDay {
    return Jiffy.parseFromDateTime(this)
        .add(days: 1)
        .startOf(Unit.day)
        .dateTime;
  }

  DateTime get endOfNextDay {
    return Jiffy.parseFromDateTime(this).add(days: 1).endOf(Unit.day).dateTime;
  }

  DateTime get startOfPrevDay {
    return Jiffy.parseFromDateTime(this)
        .subtract(days: 1)
        .startOf(Unit.day)
        .dateTime;
  }

  DateTime get endOfPrevDay {
    return Jiffy.parseFromDateTime(this)
        .subtract(days: 1)
        .endOf(Unit.day)
        .dateTime;
  }

  DateTime get startOfWeek {
    return Jiffy.parseFromDateTime(this)
        .subtract(weeks: 1)
        .startOf(Unit.day)
        .dateTime;
  }

  DateTime get endOfWeek {
    // treat end of the day as end of the week
    return Jiffy.parseFromDateTime(this).endOf(Unit.day).dateTime;
  }

  DateTime get startOfNextWeek {
    return Jiffy.parseFromDateTime(this)
        .add(days: 1)
        .startOf(Unit.day)
        .dateTime;
  }

  DateTime get endOfNextWeek {
    return Jiffy.parseFromDateTime(this)
        .add(weeks: 1)
        .subtract(milliseconds: kIsWeb ? 1 : 0)
        .endOf(Unit.day)
        .dateTime;
  }

  DateTime get startOfPrevWeek {
    return Jiffy.parseFromDateTime(this)
        .subtract(weeks: 1)
        .startOf(Unit.day)
        .dateTime;
  }

  DateTime get startOfPrevMonth {
    return Jiffy.parseFromDateTime(this)
        .subtract(months: 1)
        .startOf(Unit.month)
        .dateTime;
  }

  DateTime get endOfPrevWeek {
    return Jiffy.parseFromDateTime(this)
        .subtract(days: 1, milliseconds: kIsWeb ? 1 : 0)
        .endOf(Unit.day)
        .dateTime;
  }

  DateTime get startOfMonth {
    return Jiffy.parseFromDateTime(this).startOf(Unit.month).dateTime;
  }

  DateTime get endOfMonth {
    return Jiffy.parseFromDateTime(this)
        .endOf(Unit.month)
        .subtract(milliseconds: kIsWeb ? 1 : 0)
        .dateTime;
  }

  DateTime get endOfNextMonth {
    return Jiffy.parseFromDateTime(this)
        .add(months: 1)
        .endOf(Unit.month)
        .subtract(milliseconds: kIsWeb ? 1 : 0)
        .dateTime;
  }

  DateTime get endOfPrevMonth {
    return Jiffy.parseFromDateTime(this)
        .subtract(months: 1)
        .endOf(Unit.month)
        .subtract(milliseconds: kIsWeb ? 1 : 0)
        .dateTime;
  }

  DateTime get monthAgo {
    return Jiffy.parseFromDateTime(this)
        .subtract(months: 1)
        .startOf(Unit.day)
        .dateTime;
  }

  DateTime get yearAgo {
    return Jiffy.parseFromDateTime(this)
        .subtract(years: 1)
        .startOf(Unit.day)
        .dateTime;
  }

  bool isOnSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isOnCurrentMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  DateTime get getDateOnly {
    return DateTime(year, month, day);
  }

  String get showOnlyTime {
    return DateFormat("HH:mmm a").parse(toString()).toString();
  }

  bool isSameDate(date) {
    return date.year == year && date.Monthly == month && date.Daily == day;
  }

  bool isSameDateOrGreaterThanDate(date) {
    return isAfter(date) || isSameDate(date);
  }
}
