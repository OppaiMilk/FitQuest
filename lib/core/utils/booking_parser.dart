import 'package:calories_tracking/features/book_coaches/models/booking.dart';
import 'package:calories_tracking/features/workouts/models/workout.dart';
import 'package:calories_tracking/features/locations/models/location.dart';
import 'package:calories_tracking/features/book_coaches/models/coach.dart';
import 'package:calories_tracking/features/workouts/repositories/workout_repository.dart';
import 'package:calories_tracking/features/locations/repositories/location_repository.dart';
import 'package:calories_tracking/features/book_coaches/repositories/coach_repository.dart';

class BookingParser {
  final WorkoutRepository _workoutRepository;
  final LocationRepository _locationRepository;
  final CoachRepository _coachRepository;

  BookingParser({
    required WorkoutRepository workoutRepository,
    required LocationRepository locationRepository,
    required CoachRepository coachRepository,
  })  : _workoutRepository = workoutRepository,
        _locationRepository = locationRepository,
        _coachRepository = coachRepository;

  Future<String> parseWorkoutType(String workoutId) async {
    try {
      Workout workout = await _workoutRepository.getWorkoutDetails(workoutId);
      return workout.name;
    } catch (e) {
      print('Error parsing workout type: $e');
      return 'Unknown Workout';
    }
  }

  Future<String> parseLocation(String locationId) async {
    try {
      Location? location =
          await _locationRepository.getLocationById(locationId);
      return location?.name ?? 'Unknown Location';
    } catch (e) {
      print('Error parsing location: $e');
      return 'Unknown Location';
    }
  }

  Future<String> parseCoachName(String coachId) async {
    try {
      Coach coach = await _coachRepository.getCoachDetails(coachId);
      return coach.name;
    } catch (e) {
      print('Error parsing coach name: $e');
      return 'Unknown Coach';
    }
  }

  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<Map<String, String>> parseBooking(Booking booking) async {
    return {
      'workoutType': await parseWorkoutType(booking.workoutId),
      'location': await parseLocation(booking.locationId),
      'coachName': await parseCoachName(booking.coachId),
      'dateTime': formatDateTime(booking.dateTime),
      'status': booking.status,
    };
  }
}
