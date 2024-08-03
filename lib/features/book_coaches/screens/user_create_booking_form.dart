import 'package:calories_tracking/features/book_coaches/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/workouts/models/workout.dart';
import 'package:calories_tracking/features/workouts/repositories/workout_repository.dart';
import 'package:calories_tracking/features/locations/models/location.dart';
import 'package:calories_tracking/features/locations/repositories/location_repository.dart';

class CreateBookingForm extends StatefulWidget {
  final DateTime selectedDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const CreateBookingForm({
    Key? key,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  @override
  _CreateBookingFormState createState() => _CreateBookingFormState();
}

class _CreateBookingFormState extends State<CreateBookingForm> {
  String? selectedWorkoutId;
  String? selectedLocationId;
  late Future<List<Workout>> workoutsFuture;
  late Future<List<Location>> locationsFuture;

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
                fontWeight: FontWeight.bold))
        ,
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
                  textColor: Colors.white,
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
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildWorkoutDropdown() {
    return FutureBuilder<List<Workout>>(
      future: workoutsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No workouts available');
        }

        final workouts = snapshot.data!;
        return DropdownButtonFormField<String>(
          value: selectedWorkoutId,
          decoration: const InputDecoration(
            labelText: 'Workout Type',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          items: workouts.map((Workout workout) {
            return DropdownMenuItem<String>(
              value: workout.id,
              child: Text(workout.name),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedWorkoutId = newValue;
            });
          },
        );
      },
    );
  }

  Widget _buildLocationDropdown() {
    return FutureBuilder<List<Location>>(
      future: locationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No locations available');
        }

        final locations = snapshot.data!;
        return DropdownButtonFormField<String>(
          value: selectedLocationId,
          decoration: const InputDecoration(
            labelText: 'Location',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          items: locations.map((Location location) {
            return DropdownMenuItem<String>(
              value: location.id,
              child: Text(location.name),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedLocationId = newValue;
            });
          },
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
        return _buildDialog(
          title: 'Error',
          content: message,
          actions: [
            TextButton(
              child: const Text('OK'),
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
        return _buildDialog(
          title: 'Confirm Booking',
          content: 'Are you sure you want to create this booking?',
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirm'),
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

  Widget _buildDialog({
    required String title,
    required String content,
    required List<Widget> actions,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300, // Set a fixed width for both dialogs
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.tertiaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.tertiaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(
                color: AppTheme.tertiaryTextColor,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }

  void _createBooking() {
    // TODO: Implement actual booking creation logic here
    print('Booking created with:');
    print('Date: ${widget.selectedDate}');
    print('Start Time: ${widget.startTime}');
    print('End Time: ${widget.endTime}');
    print('Workout ID: $selectedWorkoutId');
    print('Location ID: $selectedLocationId');

    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildDialog(
          title: 'Booking Created',
          content: 'Your booking has been successfully created.',
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back to coach schedule
              },
            ),
          ],
        );
      },
    );
  }
}