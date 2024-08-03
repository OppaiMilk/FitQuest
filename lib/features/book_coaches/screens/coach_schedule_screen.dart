import 'package:calories_tracking/core/utils/time_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/models/booking.dart';
import 'package:calories_tracking/features/book_coaches/repositories/booking_repository.dart';

class CoachScheduleScreen extends StatefulWidget {
  final String coachId;

  const CoachScheduleScreen({Key? key, required this.coachId}) : super(key: key);

  @override
  _CoachScheduleScreenState createState() => _CoachScheduleScreenState();
}

class _CoachScheduleScreenState extends State<CoachScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Future<List<Booking>> _bookingsFuture;

  final List<Map<String, dynamic>> _availableSlots = [
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
    _bookingsFuture = RepositoryProvider.of<BookingRepository>(context).getBookingsForCoach(widget.coachId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Coach Schedule',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: FutureBuilder<List<Booking>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return _buildScheduleContent(context, snapshot.data!);
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildScheduleContent(BuildContext context, List<Booking> bookings) {
    return SafeArea(
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
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
              defaultTextStyle: const TextStyle(color: AppTheme.tertiaryTextColor),
              weekendTextStyle: const TextStyle(color: AppTheme.tertiaryTextColor),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Available Slots',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.tertiaryTextColor,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _availableSlots.length,
              itemBuilder: (context, index) {
                final slot = _availableSlots[index];
                final isAvailable = _selectedDay != null &&
                    _isSlotAvailable(_selectedDay!, slot['startTime'], slot['endTime'], bookings);
                return _buildBookingSlot(
                  slot['slot'],
                  slot['startTime'],
                  slot['endTime'],
                  isAvailable,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isSlotAvailable(DateTime date, TimeOfDay startTime, TimeOfDay endTime, List<Booking> bookings) {
    // Check if the selected date is today
    if (TimeParser.isToday(date)) {
      return false; // Restrict all slots if the selected date is today
    }

    // Check for conflicting bookings
    return !bookings.any((booking) =>
    booking.date.year == date.year &&
        booking.date.month == date.month &&
        booking.date.day == date.day &&
        booking.startTime == startTime &&
        booking.endTime == endTime
    );
  }

  Widget _buildBookingSlot(String slotName, TimeOfDay startTime, TimeOfDay endTime, bool isAvailable) {
    return ElevatedButton(
      onPressed: isAvailable ? () {
        // TODO: Implement booking functionality
      } : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isAvailable ? Colors.grey[200] : Colors.grey[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            slotName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isAvailable ? AppTheme.tertiaryTextColor : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${startTime.format(context)} - ${endTime.format(context)}',
            style: TextStyle(
              fontSize: 12,
              color: isAvailable ? AppTheme.tertiaryTextColor : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
