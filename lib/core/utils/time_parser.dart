import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimeParser {
  static DateTime getMalaysiaTime() {
    final now = DateTime.now().toUtc();
    return now.add(const Duration(hours: 8));
  }

  static bool isConsecutiveDay(DateTime lastCompletedDate) {
    final today = getMalaysiaTime();
    final yesterday = today.subtract(const Duration(days: 1));

    return lastCompletedDate.year == yesterday.year &&
        lastCompletedDate.month == yesterday.month &&
        lastCompletedDate.day == yesterday.day;
  }

  static bool isToday(DateTime date) {
    final today = getMalaysiaTime();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  static DateTime convertUTCToMalaysiaTime(Timestamp? timestamp) {
    if (timestamp == null) return getMalaysiaTime();
    return timestamp.toDate().toUtc().add(const Duration(hours: 8));
  }

  static DateTime convertMalaysiaTimeToUTC(DateTime malaysiaTime) {
    return malaysiaTime.subtract(const Duration(hours: 8));
  }

  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(
        dateTime.day)} '
        '${_twoDigits(dateTime.hour)}:${_twoDigits(
        dateTime.minute)}:${_twoDigits(dateTime.second)}.${_threeDigits(
        dateTime.millisecond)}';
  }

  static String formatOffset(Duration offset) {
    String sign = offset.isNegative ? '-' : '+';
    int hours = offset.inHours.abs();
    int minutes = offset.inMinutes.abs() % 60;
    return '$sign${_twoDigits(hours)}:${_twoDigits(minutes)}';
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static String _threeDigits(int n) {
    if (n >= 100) return "$n";
    if (n >= 10) return "0$n";
    return "00$n";
  }

  // New method for readable date-time formatting
  static String formatReadableDateTime(DateTime dateTime) {
    final now = getMalaysiaTime();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCompare = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (dateToCompare == today) {
      // Today
      return 'Today at ${DateFormat('h:mm a').format(dateTime)}';
    } else if (dateToCompare == yesterday) {
      // Yesterday
      return 'Yesterday at ${DateFormat('h:mm a').format(dateTime)}';
    } else if (now
        .difference(dateTime)
        .inDays < 7) {
      // Within the last week
      return '${DateFormat('EEEE').format(dateTime)} at ${DateFormat('h:mm a')
          .format(dateTime)}';
    } else {
      // More than a week ago
      return DateFormat('MMM d, yyyy \'at\' h:mm a').format(dateTime);
    }
  }
}