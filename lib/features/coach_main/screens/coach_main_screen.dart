import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/coach_main/screens/booking_approval.dart';
import 'package:calories_tracking/features/commonWidget/appbar.dart';
import 'package:calories_tracking/features/commonWidget/bottom_navigation.dart';
import 'package:calories_tracking/features/settings/screens/profile_settings.dart';
import 'package:flutter/material.dart';

class CoachMainScreen extends StatefulWidget {
  const CoachMainScreen({super.key});

  @override
  _CoachMainScreenState createState() => _CoachMainScreenState();
}

class _CoachMainScreenState extends State<CoachMainScreen> {
  int _currentIndex = 0;
  List<String> bookings = [
    'Booking 1',
    'Booking 2',
    'Booking 3',
    'Booking 4',
    'Booking 5',
  ];
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tertiaryColor,
      appBar: CustomAppBar(
        role: appbarType.coach,
        currentIndex: _currentIndex,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildSessionCount(),
          const Center(child: Text('Calendar Screen')),
          const Center(child: Text('Chat Screen')),
          const ProfileSettings()
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        role: UserRole.coach,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildSessionCount() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Text(
                  '5',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Session in the last X days',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildIncomingBooking(),
        ],
      ),
    );
  }

  Widget _buildIncomingBooking() {
    List<String> filteredBookings = bookings
        .where((approval) =>
            approval.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Incoming Bookings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildSearchBox(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(filteredBookings[index]),
                    subtitle: const Text('Description of booking here'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CoachBookingApproval()));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
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