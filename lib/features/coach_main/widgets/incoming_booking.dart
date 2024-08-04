import 'package:calories_tracking/features/coach_main/screens/booking_approval.dart';
import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';

class IncomingBooking extends StatefulWidget {
  final List<BookingData> bookings;
  final Widget Function(BuildContext, int) bookingItemBuilder;

  const IncomingBooking({
    super.key,
    required this.bookings,
    required this.bookingItemBuilder,
  });

  @override
  _IncomingBookingState createState() => _IncomingBookingState();
}

class _IncomingBookingState extends State<IncomingBooking> {
  String searchQuery = '';

  Widget _buildSearchBox() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
    );
  }

  List<BookingData> get filteredBookings {
    return widget.bookings.where((booking) {
      return booking.client.toLowerCase().contains(searchQuery.toLowerCase()) ||
          booking.location.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.tertiaryColor,
        border: Border.all(
          color: AppTheme.secondaryColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Incoming Bookings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.tertiaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSearchBox(),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: filteredBookings.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CoachBookingApproval())),
                child: widget.bookingItemBuilder(context, index),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BookingData {
  final String client;
  final String location;

  const BookingData({
    required this.client,
    required this.location,
  });
}
