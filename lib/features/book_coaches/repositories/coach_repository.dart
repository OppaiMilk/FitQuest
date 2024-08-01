import 'package:calories_tracking/features/book_coaches/models/coach.dart';

class CoachRepository {
  Future<List<Coach>> getCoaches() async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      Coach(
        id: '1',
        name: 'John Doe',
        rating: 4.8,
        email: 'john.doe@example.com',
        location: 'New York, USA',
        yearsOfExperience: 5,
        completedSessions: 120,
        workoutIds: ['w1', 'w2', 'w3'],
        profileUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '2',
        name: 'Jane Smith',
        rating: 4.9,
        email: 'jane.smith@example.com',
        location: 'Los Angeles, USA',
        yearsOfExperience: 7,
        completedSessions: 98,
        workoutIds: ['w3', 'w4'],
        profileUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '3',
        name: 'Mike Johnson',
        rating: 4.7,
        email: 'mike.johnson@example.com',
        location: 'Chicago, USA',
        yearsOfExperience: 4,
        completedSessions: 85,
        workoutIds: ['w2', 'w5'],
        profileUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '4',
        name: 'Emily Brown',
        rating: 4.6,
        email: 'emily.brown@example.com',
        location: 'Houston, USA',
        yearsOfExperience: 3,
        completedSessions: 75,
        workoutIds: ['w6', 'w7'],
        profileUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '5',
        name: 'David Lee',
        rating: 4.9,
        email: 'david.lee@example.com',
        location: 'San Francisco, USA',
        yearsOfExperience: 6,
        completedSessions: 110,
        workoutIds: ['w8', 'w9'],
        profileUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '6',
        name: 'Sarah Wilson',
        rating: 4.8,
        email: 'sarah.wilson@example.com',
        location: 'Boston, USA',
        yearsOfExperience: 8,
        completedSessions: 130,
        workoutIds: ['w10', 'w11'],
        profileUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '7',
        name: 'Tom Harris',
        rating: 4.5,
        email: 'tom.harris@example.com',
        location: 'Seattle, USA',
        yearsOfExperience: 2,
        completedSessions: 50,
        workoutIds: ['w12', 'w13'],
        profileUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '8',
        name: 'Lisa Chen',
        rating: 4.7,
        email: 'lisa.chen@example.com',
        location: 'Miami, USA',
        yearsOfExperience: 5,
        completedSessions: 95,
        workoutIds: ['w14', 'w15'],
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