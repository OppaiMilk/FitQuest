import '../models/coach.dart';

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
        workouts: ['HIIT', 'Strength Training'],
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '2',
        name: 'Jane Smith',
        rating: 4.9,
        email: 'jane.smith@example.com',
        location: 'Los Angeles, USA',
        yearsOfExperience: 7,
        completedSessions: 98,
        workouts: ['Yoga', 'Pilates'],
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '3',
        name: 'Mike Johnson',
        rating: 4.7,
        email: 'mike.johnson@example.com',
        location: 'Chicago, USA',
        yearsOfExperience: 4,
        completedSessions: 85,
        workouts: ['Crossfit', 'Weightlifting'],
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '4',
        name: 'Emily Brown',
        rating: 4.6,
        email: 'emily.brown@example.com',
        location: 'Houston, USA',
        yearsOfExperience: 3,
        completedSessions: 75,
        workouts: ['Zumba', 'Aerobics'],
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '5',
        name: 'David Lee',
        rating: 4.9,
        email: 'david.lee@example.com',
        location: 'San Francisco, USA',
        yearsOfExperience: 6,
        completedSessions: 110,
        workouts: ['Boxing', 'Kickboxing'],
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '6',
        name: 'Sarah Wilson',
        rating: 4.8,
        email: 'sarah.wilson@example.com',
        location: 'Boston, USA',
        yearsOfExperience: 8,
        completedSessions: 130,
        workouts: ['Running', 'Marathon Prep'],
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '7',
        name: 'Tom Harris',
        rating: 4.5,
        email: 'tom.harris@example.com',
        location: 'Seattle, USA',
        yearsOfExperience: 2,
        completedSessions: 50,
        workouts: ['Swimming', 'Triathlon'],
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '8',
        name: 'Lisa Chen',
        rating: 4.7,
        email: 'lisa.chen@example.com',
        location: 'Miami, USA',
        yearsOfExperience: 5,
        completedSessions: 95,
        workouts: ['Tai Chi', 'Meditation'],
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '9',
        name: 'Alex Turner',
        rating: 4.6,
        email: 'alex.turner@example.com',
        location: 'Denver, USA',
        yearsOfExperience: 4,
        completedSessions: 80,
        workouts: [],
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Coach(
        id: '10',
        name: 'Olivia Parker',
        rating: 4.8,
        email: 'olivia.parker@example.com',
        location: 'Austin, USA',
        yearsOfExperience: 6,
        completedSessions: 105,
        workouts: ['Ballet Fitness'],
        imageUrl: 'https://via.placeholder.com/150',

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
        workouts: ['No workouts available'],
        imageUrl: 'https://via.placeholder.com/150',
      ),
    );
  }
}