import 'package:calories_tracking/core/utils/time_parser.dart';
import 'package:calories_tracking/features/book_coaches/models/booking.dart';
import 'package:flutter/material.dart';

class BookingRepository {
  Future<List<Booking>> getBookings() async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      Booking(
        bookingId: 'B1',
        coachId: 'C1',
        userId: 'U1',
        date: TimeParser.getMalaysiaTime().add(const Duration(days: 1)),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
      ),
      Booking(
        bookingId: 'B2',
        coachId: 'C1',
        userId: 'U2',
        date: TimeParser.getMalaysiaTime().add(const Duration(days: 1)),
        startTime: const TimeOfDay(hour: 16, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
      ),
      Booking(
        bookingId: 'B3',
        coachId: 'C2',
        userId: 'U1',
        date: TimeParser.getMalaysiaTime().add(const Duration(days: 2)),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 15, minute: 0),
      ),
      Booking(
        bookingId: 'B4',
        coachId: 'C2',
        userId: 'U3',
        date: TimeParser.getMalaysiaTime().add(const Duration(days: 3)),
        startTime: const TimeOfDay(hour: 16, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
      ),
    ];
  }

  Future<Booking> getBookingDetails(String id) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));

    final bookings = await getBookings();
    return bookings.firstWhere(
      (booking) => booking.bookingId == id,
      orElse: () => Booking(
        bookingId: id,
        coachId: 'Unknown',
        userId: 'Unknown',
        date: DateTime.now(),
        startTime: const TimeOfDay(hour: 0, minute: 0),
        endTime: const TimeOfDay(hour: 0, minute: 0),
      ),
    );
  }

  Future<List<Booking>> getBookingsForCoach(String coachId) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));

    final bookings = await getBookings();
    return bookings.where((booking) => booking.coachId == coachId).toList();
  }

  Future<List<Booking>> getBookingsForUser(String userId) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));

    final bookings = await getBookings();
    return bookings.where((booking) => booking.userId == userId).toList();
  }

  Future<bool> createBooking(Booking booking) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> cancelBooking(String bookingId) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
