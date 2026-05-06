import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String get toReadableDate => DateFormat('dd MMM yyyy').format(this);

  String get toReadableTime => DateFormat('hh:mm a').format(this);

  String get toDateTimeString =>
      DateFormat('dd MMM yyyy – hh:mm a').format(this);

  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }
}
