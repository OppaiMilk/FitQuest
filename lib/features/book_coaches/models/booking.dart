import 'package:flutter/material.dart';

class Booking {
  final String bookingId;
  final String coachId;
  final String userId;
  final String locationId;
  final String workoutId;
  final DateTime dateTime;
  final String status;
  final String cancelDescription;

  Booking({
    required this.bookingId,
    required this.coachId,
    required this.userId,
    required this.locationId,
    required this.workoutId,
    required this.dateTime,
    required this.status,
    required this.cancelDescription,
  });

  TimeOfDay get startTime =>
      TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

  DateTime get date => DateTime(dateTime.year, dateTime.month, dateTime.day);
}
