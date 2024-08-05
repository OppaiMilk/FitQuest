import 'package:calories_tracking/features/book_coaches/widgets/custom_button.dart';
import 'package:calories_tracking/features/user_main/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/workouts/models/workout.dart';
import 'package:calories_tracking/features/workouts/repositories/workout_repository.dart';
import 'package:calories_tracking/features/locations/models/location.dart';
import 'package:calories_tracking/features/locations/repositories/location_repository.dart';
import 'package:calories_tracking/features/book_coaches/models/booking.dart';
import 'package:calories_tracking/features/book_coaches/repositories/booking_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBookingForm extends StatefulWidget {
  final DateTime selectedDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String coachId;

  const CreateBookingForm({
    super.key,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.coachId,
  });

  @override
  _CreateBookingFormState createState() => _CreateBookingFormState();
}

class _CreateBookingFormState extends State<CreateBookingForm> {
  String? selectedWorkoutId;
  String? selectedLocationId;
  late Future<List<Workout>> workoutsFuture;
  late Future<List<Location>> locationsFuture;
  final BookingRepository _bookingRepository = BookingRepository();

  @override
  void initState() {
    super.initState();
    workoutsFuture = WorkoutRepository().getWorkouts();
    locationsFuture = LocationRepository().getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Booking',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryColor,
      ),
      backgroundColor: AppTheme.tertiaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.tertiaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please fill in your booking details',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              _buildDateTimeField('Date', '${widget.selectedDate.toLocal()}'.split(' ')[0]),
              const SizedBox(height: 16),
              _buildDateTimeField('Start Time', widget.startTime.format(context)),
              const SizedBox(height: 16),
              _buildDateTimeField('End Time', widget.endTime.format(context)),
              const SizedBox(height: 24),
              _buildWorkoutDropdown(),
              const SizedBox(height: 24),
              _buildLocationDropdown(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  label: 'Create Booking',
                  backgroundColor: AppTheme.primaryColor,
                  textColor: AppTheme.primaryTextColor,
                  onPressed: _handleCreateBooking,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField(String label, String value) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.secondaryTextColor),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.secondaryColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primaryColor),
        ),
        filled: true,
        fillColor: AppTheme.tertiaryColor,
      ),
      style: const TextStyle(color: AppTheme.tertiaryTextColor),
    );
  }

  Widget _buildWorkoutDropdown() {
    return FutureBuilder<List<Workout>>(
      future: workoutsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: AppTheme.primaryColor);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: const TextStyle(color: AppTheme.tertiaryTextColor));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No workouts available', style: TextStyle(color: AppTheme.secondaryTextColor));
        }

        final workouts = snapshot.data!;
        return DropdownButtonFormField<String>(
          value: selectedWorkoutId,
          decoration: const InputDecoration(
            labelText: 'Workout Type',
            labelStyle: TextStyle(color: AppTheme.secondaryTextColor),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.secondaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
            filled: true,
            fillColor: AppTheme.tertiaryColor,
          ),
          items: workouts.map((Workout workout) {
            return DropdownMenuItem<String>(
              value: workout.id,
              child: Text(workout.name, style: const TextStyle(color: AppTheme.tertiaryTextColor)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedWorkoutId = newValue;
            });
          },
          dropdownColor: AppTheme.tertiaryColor,
        );
      },
    );
  }

  Widget _buildLocationDropdown() {
    return FutureBuilder<List<Location>>(
      future: locationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: AppTheme.primaryColor);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: const TextStyle(color: AppTheme.tertiaryTextColor));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No locations available', style: TextStyle(color: AppTheme.secondaryTextColor));
        }

        final locations = snapshot.data!;
        return DropdownButtonFormField<String>(
          value: selectedLocationId,
          decoration: const InputDecoration(
            labelText: 'Location',
            labelStyle: TextStyle(color: AppTheme.secondaryTextColor),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.secondaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
            filled: true,
            fillColor: AppTheme.tertiaryColor,
          ),
          items: locations.map((Location location) {
            return DropdownMenuItem<String>(
              value: location.id,
              child: Text(location.name, style: const TextStyle(color: AppTheme.tertiaryTextColor)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedLocationId = newValue;
            });
          },
          dropdownColor: AppTheme.tertiaryColor,
        );
      },
    );
  }

  void _handleCreateBooking() {
    if (selectedWorkoutId == null || selectedLocationId == null) {
      _showErrorDialog('Please fill in all fields');
    } else {
      _showConfirmationDialog();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error', style: TextStyle(color: AppTheme.tertiaryTextColor)),
          content: Text(message, style: const TextStyle(color: AppTheme.tertiaryTextColor)),
          backgroundColor: AppTheme.tertiaryColor,
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(color: AppTheme.primaryColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Booking', style: TextStyle(color: AppTheme.tertiaryTextColor)),
          content: const Text('Are you sure you want to create this booking?', style: TextStyle(color: AppTheme.tertiaryTextColor)),
          backgroundColor: AppTheme.tertiaryColor,
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: AppTheme.tertiaryTextColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirm', style: TextStyle(color: AppTheme.tertiaryTextColor)),
              onPressed: () {
                Navigator.of(context).pop();
                _createBooking();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _getNextBookingId() async {
    List<Booking> allBookings = await _bookingRepository.getBookings();
    int maxId = 0;
    for (var booking in allBookings) {
      if (booking.bookingId.startsWith('B')) {
        int id = int.tryParse(booking.bookingId.substring(1)) ?? 0;
        if (id > maxId) maxId = id;
      }
    }
    return 'B${maxId + 1}';
  }

  void _createBooking() async {
    final userBloc = BlocProvider.of<UserBloc>(context);
    final userState = userBloc.state;

    if (userState is UserLoaded) {
      final userId = userState.user.id;
      final String bookingId = await _getNextBookingId();

      // Combine the selected date and start time
      final DateTime bookingDateTime = DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
        widget.startTime.hour,
        widget.startTime.minute,
      );

      final booking = Booking(
        bookingId: bookingId,
        coachId: widget.coachId,
        userId: userId,
        locationId: selectedLocationId!,
        workoutId: selectedWorkoutId!,
        dateTime: bookingDateTime,
        status: 'pending',
        cancelDescription: '',
      );

      try {
        bool success = await _bookingRepository.createBooking(booking);
        if (success) {
          _showSuccessDialog();
        } else {
          _showErrorDialog('Failed to create booking. Please try again.');
        }
      } catch (e) {
        _showErrorDialog('An error occurred: $e');
      }
    } else {
      _showErrorDialog('User not found. Please log in again.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Created', style: TextStyle(color: AppTheme.tertiaryTextColor)),
          content: const Text('Your booking has been successfully created.', style: TextStyle(color: AppTheme.tertiaryTextColor)),
          backgroundColor: AppTheme.tertiaryColor,
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(color: AppTheme.primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}