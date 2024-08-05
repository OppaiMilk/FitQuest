import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:calories_tracking/features/book_coaches/models/booking.dart';
import 'package:calories_tracking/features/book_coaches/repositories/booking_repository.dart';

class CancelBookingScreen extends StatefulWidget {
  final Booking booking;

  const CancelBookingScreen({super.key, required this.booking});

  @override
  _CancelBookingScreenState createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  final TextEditingController _explanationController = TextEditingController();
  final BookingRepository _bookingRepository = BookingRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryTextColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Cancel Booking',
            style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _explanationController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Please enter your explanation here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: 'Submit',
                    backgroundColor: Colors.grey,
                    textColor: Colors.black,
                    onPressed: () async {
                      final explanation = _explanationController.text.trim();

                      if (explanation.isEmpty) {
                        _showEmptyReasonDialog();
                      } else {
                        _showConfirmationDialog(explanation);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEmptyReasonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Cancellation Reason Required',
            style: TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          content: const Text(
            'Please enter a reason for cancelling the booking.',
            style: TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: AppTheme.tertiaryColor,
        );
      },
    );
  }

  void _showConfirmationDialog(String explanation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Cancellation',
            style: TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          content: const Text(
            'Are you sure you want to cancel this booking? This action cannot be undone.',
            style: TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
            ),
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the confirmation dialog

                final success = await _bookingRepository.cancelBooking(
                  widget.booking.bookingId,
                  explanation,
                );

                if (success) {
                  _showSuccessDialog();
                } else {
                  _showErrorDialog();
                }
              },
            ),
          ],
          backgroundColor: AppTheme.tertiaryColor,
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Cancellation Successful',
            style: TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          content: const Text(
            'Your booking has been successfully cancelled.',
            style: TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the success dialog
                Navigator.pop(context); // Return to BookingDetailsScreen
                Navigator.pop(context); // Return to UserBookingsScreen
              },
            ),
          ],
          backgroundColor: AppTheme.tertiaryColor,
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          content: const Text(
            'Failed to cancel the booking. Please try again later.',
            style: TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: AppTheme.tertiaryColor,
        );
      },
    );
  }

  @override
  void dispose() {
    _explanationController.dispose();
    super.dispose();
  }
}
