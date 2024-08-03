import 'package:calories_tracking/features/book_coaches/models/coach.dart';
import 'package:calories_tracking/features/workouts/models/workout.dart';

class CoachWorkoutParser {
  static Future<Map<String, dynamic>> parseCoachWithWorkouts(
    Coach coach,
    List<Workout> allWorkouts,
  ) async {
    final coachWorkouts = allWorkouts
        .where((workout) => coach.workoutIds.contains(workout.id))
        .toList();

    return {
      'coach': coach,
      'workouts': coachWorkouts,
    };
  }

  static Future<List<Map<String, dynamic>>> parseCoachesWithWorkouts(
    List<Coach> coaches,
    List<Workout> allWorkouts,
  ) async {
    return Future.wait(
      coaches.map((coach) => parseCoachWithWorkouts(coach, allWorkouts)),
    );
  }
}
