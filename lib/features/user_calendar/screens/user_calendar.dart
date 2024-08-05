import 'package:calories_tracking/core/utils/time_parser.dart';
import 'package:calories_tracking/features/user_calendar/screens/booking_detail_screen.dart';
import 'package:calories_tracking/features/user_main/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/models/booking.dart';
import 'package:calories_tracking/features/book_coaches/repositories/booking_repository.dart';

class UserBookingsScreen extends StatefulWidget {
  const UserBookingsScreen({super.key});

  @override
  _UserBookingsScreenState createState() => _UserBookingsScreenState();
}

class _UserBookingsScreenState extends State<UserBookingsScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  List<Booking> _allBookings = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _bookedSlots = [
    {'slot': 'Slot 1', 'startTime': const TimeOfDay(hour: 10, minute: 0), 'endTime': const TimeOfDay(hour: 11, minute: 0)},
    {'slot': 'Slot 2', 'startTime': const TimeOfDay(hour: 12, minute: 0), 'endTime': const TimeOfDay(hour: 13, minute: 0)},
    {'slot': 'Slot 3', 'startTime': const TimeOfDay(hour: 14, minute: 0), 'endTime': const TimeOfDay(hour: 15, minute: 0)},
    {'slot': 'Slot 4', 'startTime': const TimeOfDay(hour: 16, minute: 0), 'endTime': const TimeOfDay(hour: 17, minute: 0)},
    {'slot': 'Slot 5', 'startTime': const TimeOfDay(hour: 18, minute: 0), 'endTime': const TimeOfDay(hour: 19, minute: 0)},
    {'slot': 'Slot 6', 'startTime': const TimeOfDay(hour: 20, minute: 0), 'endTime': const TimeOfDay(hour: 21, minute: 0)},
  ];

  @override
  void initState() {
    super.initState();
    _focusedDay = TimeParser.getMalaysiaTime();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          if (_isLoading) {
            _fetchAllBookings(state.user.id);
          }
          return _buildContent();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _fetchAllBookings(String userId) async {
    final BookingRepository bookingRepository = RepositoryProvider.of<BookingRepository>(context);
    final userBookings = await bookingRepository.getBookingsForUser(userId);
    setState(() {
      _allBookings = userBookings;
      _isLoading = false;
    });
  }

  Widget _buildContent() {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildCalendar(),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Bookings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.tertiaryTextColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildBookingSlotsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: TimeParser.getMalaysiaTime(),
      lastDay: TimeParser.getMalaysiaTime().add(const Duration(days: 365)),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: CalendarFormat.month,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          color: AppTheme.tertiaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leftChevronIcon: Icon(Icons.chevron_left, color: AppTheme.primaryColor),
        rightChevronIcon: Icon(Icons.chevron_right, color: AppTheme.primaryColor),
      ),
      calendarStyle: CalendarStyle(
        selectedDecoration: const BoxDecoration(
          color: AppTheme.primaryColor,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(
          color: AppTheme.primaryTextColor,
          fontWeight: FontWeight.bold,
        ),
        defaultTextStyle: const TextStyle(color: AppTheme.tertiaryTextColor),
        weekendTextStyle: const TextStyle(color: AppTheme.tertiaryTextColor),
      ),
    );
  }

  Widget _buildBookingSlotsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _bookedSlots.length,
      itemBuilder: (context, index) {
        final slot = _bookedSlots[index];
        final isBooked = _isSlotBooked(_selectedDay, slot['startTime'], slot['endTime']);
        return _buildBookingSlot(slot['slot'], slot['startTime'], slot['endTime'], isBooked);
      },
    );
  }

  bool _isSlotBooked(DateTime date, TimeOfDay startTime, TimeOfDay endTime) {
    return _allBookings.any((booking) =>
    booking.dateTime.year == date.year &&
        booking.dateTime.month == date.month &&
        booking.dateTime.day == date.day &&
        booking.startTime.hour == startTime.hour &&
        booking.startTime.minute == startTime.minute
    );
  }

  Widget _buildBookingSlot(String slotName, TimeOfDay startTime, TimeOfDay endTime, bool isBooked) {
    return ElevatedButton(
      onPressed: isBooked
          ? () {
        final selectedBooking = _allBookings.firstWhere(
              (booking) =>
          booking.dateTime.year == _selectedDay.year &&
              booking.dateTime.month == _selectedDay.month &&
              booking.dateTime.day == _selectedDay.day &&
              booking.startTime.hour == startTime.hour &&
              booking.startTime.minute == startTime.minute,
          orElse: () => throw Exception('Booking not found'),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetailsScreen(booking: selectedBooking),
          ),
        ).then((_) => _refreshBookings());
      }
          : null,
      style: ElevatedButton.styleFrom(
        elevation: isBooked ? 2 : 0,
        backgroundColor: isBooked ? AppTheme.primaryColor : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            slotName,
            style: TextStyle(
              color: isBooked ? AppTheme.primaryTextColor : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${startTime.format(context)} - ${endTime.format(context)}',
            style: TextStyle(
              color: isBooked ? AppTheme.primaryTextColor : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  void _refreshBookings() {
    setState(() {
      _isLoading = true;
    });
  }
}