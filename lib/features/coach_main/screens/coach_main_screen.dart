import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/models/booking.dart';
import 'package:calories_tracking/features/book_coaches/models/coach.dart';
import 'package:calories_tracking/features/coach_calendar/screens/coach_calendar.dart';
import 'package:calories_tracking/features/coach_main/bloc/booking_bloc.dart';
import 'package:calories_tracking/features/coach_main/bloc/coach_bloc.dart';
import 'package:calories_tracking/features/coach_main/widgets/booking_item.dart';
import 'package:calories_tracking/features/coach_main/widgets/incoming_booking.dart';
import 'package:calories_tracking/features/coach_main/widgets/session_count.dart';
import 'package:calories_tracking/features/commonWidget/bottom_navigation.dart';
import 'package:calories_tracking/features/locations/repositories/location_repository.dart';
import 'package:calories_tracking/features/settings/screens/profile_settings.dart';
import 'package:calories_tracking/features/user_main/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachMainScreen extends StatefulWidget {
  const CoachMainScreen({super.key});

  @override
  _CoachMainScreenState createState() => _CoachMainScreenState();
}

class _CoachMainScreenState extends State<CoachMainScreen> {
  int _currentIndex = 0;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tertiaryColor,
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildMainContent(),
          const CoachCalendarScreen(),
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      title: BlocBuilder<CoachBloc, CoachState>(
        builder: (context, state) {
          if (state is CoachLoaded) {
            return _buildWelcomeText(state.coach.name);
          }
          return const Text('Loading...');
        },
      ),
    );
  }

  Widget _buildWelcomeText(String coachName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome Back',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          coachName,
          style: const TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return BlocBuilder<CoachBloc, CoachState>(
      builder: (context, coachState) {
        if (coachState is CoachLoaded) {
          return BlocBuilder<BookingBloc, BookingState>(
            builder: (context, bookingState) {
              if (bookingState is BookingInitial) {
                context.read<BookingBloc>().add(FetchBooking());
              }
              if (bookingState is BookingLoaded) {
                return _buildSessionCount(coachState.coach, bookingState);
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildSessionCount(Coach coach, BookingLoaded bookingState) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: SessionCount(
              sessionCount: coach.completedSessions,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          sliver: SliverToBoxAdapter(
            child: _buildIncomingBooking(coach.id, bookingState),
          ),
        ),
      ],
    );
  }

  Widget _buildIncomingBooking(String coachId, BookingLoaded bookingState) {
    final coachBookings = bookingState.bookings
        .where((booking) =>
            booking.coachId == coachId &&
            (booking.dateTime.isAfter(DateTime.now()) ||
                booking.dateTime.isAtSameMomentAs(DateTime.now())) &&
            booking.status != "cancelled")
        .toList();

    return FutureBuilder<List<Booking>>(
      future: _getBookingDataWithUserNames(coachBookings),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return IncomingBooking(
            bookings: snapshot.data!,
            bookingItemBuilder: (context, booking) =>
                _buildBookingItem(context, booking),
          );
        } else {
          return const Text('No bookings available');
        }
      },
    );
  }

  Future<List<Booking>> _getBookingDataWithUserNames(
      List<Booking> bookings) async {
    final userRepository = UserRepository();
    final locationRepository = LocationRepository();
    List<Booking> updatedBookings = [];

    for (var booking in bookings) {
      final user = await userRepository.getUserById(booking.userId);
      final location =
          await locationRepository.getLocationById(booking.locationId);
      print('User Name: ${user.name}');
      updatedBookings.add(booking.copyWith(
        clientName: user.name,
        locationName: location!.name,
      ));
    }

    return updatedBookings;
  }

  Widget _buildBookingItem(BuildContext context, Booking booking) {
    print('Client Name: ${booking.clientName}');  
    return BookingItem(
      client: booking.clientName ?? 'Unknown User',
      location: booking.locationName ?? 'Unknown Location',
    );
  }
}
