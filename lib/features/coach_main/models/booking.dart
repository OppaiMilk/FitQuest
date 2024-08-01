import 'package:flutter/material.dart';

enum Status { pending, approved, rejected }

class Booking {
  final String id;
  final DateTime date;
  final TimeOfDay time;
  final String type;
  final String location;
  final Status status;

  Booking({
    required this.id,
    required this.date,
    required this.time,
    required this.type,
    required this.location,
    required this.status,
  });
}
