import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calories_tracking/features/book_coaches/models/booking.dart';
import 'package:calories_tracking/core/utils/time_parser.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Booking>> getBookings() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('bookings').get();
      return querySnapshot.docs.map((doc) {
        return Booking(
          bookingId: doc.id,
          coachId: doc['coachId'],
          userId: doc['userId'],
          locationId: doc['locationId'],
          workoutId: doc['workoutId'],
          dateTime: TimeParser.convertUTCToMalaysiaTime(doc['date'] as Timestamp?),
          status: doc['status'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }

  Future<Booking> getBookingDetails(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('bookings').doc(id).get();
      if (doc.exists) {
        return Booking(
          bookingId: doc.id,
          coachId: doc['coachId'] ?? 'Unknown',
          userId: doc['userId'] ?? 'Unknown',
          locationId: doc['locationId'] ?? 'Unknown',
          workoutId: doc['workoutId'] ?? 'Unknown',
          dateTime: TimeParser.convertUTCToMalaysiaTime(doc['date'] as Timestamp?),
          status: doc['status'] ?? 'Unknown',
        );
      } else {
        return Booking(
          bookingId: id,
          coachId: 'Unknown',
          userId: 'Unknown',
          locationId: 'Unknown',
          workoutId: 'Unknown',
          dateTime: TimeParser.getMalaysiaTime(),
          status: 'Unknown',
        );
      }
    } catch (e) {
      print('Error fetching booking details: $e');
      return Booking(
        bookingId: id,
        coachId: 'Error',
        userId: 'Error',
        locationId: 'Error',
        workoutId: 'Error',
        dateTime: TimeParser.getMalaysiaTime(),
        status: 'Error',
      );
    }
  }

  Future<List<Booking>> getBookingsForCoach(String coachId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('bookings')
          .where('coachId', isEqualTo: coachId)
          .get();
      return querySnapshot.docs.map((doc) {
        return Booking(
          bookingId: doc.id,
          coachId: doc['coachId'] ?? 'Unknown',
          userId: doc['userId'] ?? 'Unknown',
          locationId: doc['locationId'] ?? 'Unknown',
          workoutId: doc['workoutId'] ?? 'Unknown',
          dateTime: TimeParser.convertUTCToMalaysiaTime(doc['date'] as Timestamp?),
          status: doc['status'] ?? 'Unknown',
        );
      }).toList();
    } catch (e) {
      print('Error fetching bookings for coach: $e');
      return [];
    }
  }

  Future<List<Booking>> getBookingsForUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs.map((doc) {
        return Booking(
          bookingId: doc.id,
          coachId: doc['coachId'] ?? 'Unknown',
          userId: doc['userId'] ?? 'Unknown',
          locationId: doc['locationId'] ?? 'Unknown',
          workoutId: doc['workoutId'] ?? 'Unknown',
          dateTime: TimeParser.convertUTCToMalaysiaTime(doc['date'] as Timestamp?),
          status: doc['status'] ?? 'Unknown',
        );
      }).toList();
    } catch (e) {
      print('Error fetching bookings for user: $e');
      return [];
    }
  }

  Future<bool> createBooking(Booking booking) async {
    try {
      final utcDateTime = TimeParser.convertMalaysiaTimeToUTC(booking.dateTime);

      await _firestore.collection('bookings').doc(booking.bookingId).set({
        'coachId': booking.coachId,
        'userId': booking.userId,
        'locationId': booking.locationId,
        'workoutId': booking.workoutId,
        'date': Timestamp.fromDate(utcDateTime),
        'status': booking.status,
      });
      return true;
    } catch (e) {
      print('Error creating booking: $e');
      return false;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({'status': 'cancelled'});
      return true;
    } catch (e) {
      print('Error cancelling booking: $e');
      return false;
    }
  }

}