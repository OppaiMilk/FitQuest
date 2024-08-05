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
  final String? clientName;
  final String? locationName;

  Booking({
    required this.bookingId,
    required this.coachId,
    required this.userId,
    required this.locationId,
    required this.workoutId,
    required this.dateTime,
    required this.status,
    required this.cancelDescription,
    this.clientName,
    this.locationName,
  });

  TimeOfDay get startTime => TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

  DateTime get date => DateTime(dateTime.year, dateTime.month, dateTime.day);

  Booking copyWith({
    String? bookingId,
    String? coachId,
    String? userId,
    String? locationId,
    String? workoutId,
    DateTime? dateTime,
    String? status,
    String? cancelDescription,
    String? clientName,
    String? locationName,
  }) {
    return Booking(
      bookingId: bookingId ?? this.bookingId,
      coachId: coachId ?? this.coachId,
      userId: userId ?? this.userId,
      locationId: locationId ?? this.locationId,
      workoutId: workoutId ?? this.workoutId,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      cancelDescription: cancelDescription ?? this.cancelDescription,
      clientName: clientName ?? this.clientName,
      locationName: locationName ?? this.locationName,
    );
  }
}