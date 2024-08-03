import 'package:flutter/material.dart';

class Booking {
  final String bookingId;
  final String coachId;
  final String userId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Booking({
    required this.bookingId,
    required this.coachId,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
}