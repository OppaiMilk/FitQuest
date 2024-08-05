import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/core/utils/booking_parser.dart';
import 'package:calories_tracking/features/book_coaches/models/booking.dart';
import 'package:calories_tracking/features/book_coaches/widgets/custom_button.dart';
import 'package:calories_tracking/features/user_calendar/screens/cancel_booking_screen.dart';
import 'package:calories_tracking/features/workouts/repositories/workout_repository.dart';
import 'package:calories_tracking/features/locations/repositories/location_repository.dart';
import 'package:calories_tracking/features/book_coaches/repositories/coach_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;
  final BookingParser _bookingParser;

  BookingDetailsScreen({super.key, required this.booking})
      : _bookingParser = BookingParser(
          workoutRepository: WorkoutRepository(),
          locationRepository: LocationRepository(),
          coachRepository: CoachRepository(),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tertiaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'Booking Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryTextColor,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _bookingParser.parseBooking(booking),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final parsedData = snapshot.data!;
            return _buildBookingDetails(context, parsedData);
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildBookingDetails(
      BuildContext context, Map<String, String> parsedData) {
    final endTime = booking.startTime.hour < 23
        ? TimeOfDay(
            hour: booking.startTime.hour + 1, minute: booking.startTime.minute)
        : const TimeOfDay(hour: 0, minute: 0);

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              Scaffold.of(context).appBarMaxHeight!,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parsedData['coachName'] ?? 'Unknown Coach',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.tertiaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                      'Workout Type:', parsedData['workoutType'] ?? 'Unknown'),
                  _buildDetailRow(
                      'Location:', parsedData['location'] ?? 'Unknown'),
                  _buildDetailRow('Date:',
                      DateFormat('MMMM d, y').format(booking.dateTime)),
                  _buildDetailRow(
                      'Start Time:', booking.startTime.format(context)),
                  _buildDetailRow('End Time:', endTime.format(context)),
                  _buildDetailRow('Status:', parsedData['status'] ?? 'Unknown'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: 'Cancel Booking',
                      backgroundColor: AppTheme.primaryColor,
                      textColor: AppTheme.primaryTextColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CancelBookingScreen(booking: booking),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.tertiaryTextColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.tertiaryTextColor,
                ),
            ),
          ),
        ],
      ),
    );
  }
}
