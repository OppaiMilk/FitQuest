import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:calories_tracking/features/book_coaches/models/booking.dart';

class CancelBookingScreen extends StatefulWidget {
  final Booking booking;

  const CancelBookingScreen({super.key, required this.booking});

  @override
  _CancelBookingScreenState createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  final TextEditingController _explanationController = TextEditingController();

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
        title: const Text('Coaches',
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
                    onPressed: () {
                      // TODO: Implement cancellation logic
                      print('Booking cancelled with explanation: ${_explanationController.text}');
                      Navigator.pop(context); // Return to BookingDetailsScreen
                      Navigator.pop(context); // Return to UserBookingsScreen
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

  @override
  void dispose() {
    _explanationController.dispose();
    super.dispose();
  }
}