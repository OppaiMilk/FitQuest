import 'package:calories_tracking/features/coach_main/models/booking.dart';
import 'package:flutter/material.dart';


class BookingRepository {
  Future<List<Booking>> getBookings() async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      Booking(
        id: '1',
        date: DateTime(2024, 8, 2),
        time: const TimeOfDay(hour: 12, minute: 30),
        type: 'Gym',
        location: 'Online',
        status: Status.pending,
      ),
    ];
  }

  Future<Booking> getBookingDetails(String id) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));

    final bookings = await getBookings();
    return bookings.firstWhere(
      (booking) => booking.id == id,
      orElse: () => Booking(
        id: id,
        date: DateTime(2000, 1, 1),
        time: const TimeOfDay(hour: 0, minute: 0),
        type: 'Unknown Type',
        location: 'Unknown Location',
        status: Status.pending,
      ),
    );
  }
}