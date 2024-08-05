import 'package:calories_tracking/features/book_coaches/models/booking.dart';
import 'package:calories_tracking/features/coach_main/screens/booking_details.dart';
import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';

class IncomingBooking extends StatefulWidget {
  List<Booking> bookings;
  final Widget Function(BuildContext, Booking) bookingItemBuilder;

  IncomingBooking({
    super.key,
    required this.bookings,
    required this.bookingItemBuilder,
  });

  @override
  _IncomingBookingState createState() => _IncomingBookingState();
}

class _IncomingBookingState extends State<IncomingBooking> {
  String searchQuery = '';

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
          _buildBookingListView(),
        ],
      ),
    );
  }

  Widget _buildBookingListView() {
    List<Booking> filteredBookings = widget.bookings.where((booking) {
      return booking.clientName!.toLowerCase().contains(searchQuery.toLowerCase()) ||
             booking.dateTime.toString().contains(searchQuery);
    }).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoachBookingDetails(booking: booking),
              ),
            );
          },
          child: widget.bookingItemBuilder(context, booking),
        );
      },
    );
  }

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
}
