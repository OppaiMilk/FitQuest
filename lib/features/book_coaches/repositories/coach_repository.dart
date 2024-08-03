import 'package:calories_tracking/features/book_coaches/models/coach.dart';

class CoachRepository {
  Future<List<Coach>> getCoaches() async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      Coach(
        id: '1',
        name: 'John Doe',
        numOfRatings: 20,
        rating: 4.8,
        email: 'john.doe@example.com',
        location: 'Seri Kembangan',
        yearsOfExperience: 5,
        completedSessions: 120,
        workoutIds: ['w1', 'w2', 'w3'],
        profileUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '2',
        name: 'Jane Smith',
        numOfRatings: 13,
        rating: 4.9,
        email: 'jane.smith@example.com',
        location: 'Kuala Lumpur',
        yearsOfExperience: 7,
        completedSessions: 98,
        workoutIds: ['w3', 'w4'],
        profileUrl: 'https://via.placeholder.com/150',
      ),
    ];
  }

  Future<Coach> getCoachDetails(String id) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));

    final coaches = await getCoaches();
    return coaches.firstWhere(
      (coach) => coach.id == id,
      orElse: () => Coach(
        id: id,
        name: 'Unknown Coach',
        numOfRatings: 0,
        rating: 0.0,
        email: 'unknown@example.com',
        location: 'Unknown Location',
        yearsOfExperience: 0,
        completedSessions: 0,
        workoutIds: [],
        profileUrl: 'https://via.placeholder.com/150',
      ),
    );
  }
}
