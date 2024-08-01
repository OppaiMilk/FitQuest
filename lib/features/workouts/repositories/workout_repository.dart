import 'package:calories_tracking/features/workouts/models/workout.dart';

class WorkoutRepository {
  Future<List<Workout>> getWorkouts() async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      Workout(
        id: 'w1',
        name: 'HIIT',
        description: 'High-Intensity Interval Training',
        url: 'https://example.com/hiit',
      ),
      Workout(
        id: 'w2',
        name: 'Strength Training',
        description: 'Build muscle and strength',
        url: 'https://example.com/strength',
      ),
      Workout(
        id: 'w3',
        name: 'Yoga',
        description: 'Improve flexibility and mindfulness',
        url: 'https://example.com/yoga',
      ),
      Workout(
        id: 'w4',
        name: 'Pilates',
        description: 'Core strengthening and body alignment',
        url: 'https://example.com/pilates',
      ),
      Workout(
        id: 'w5',
        name: 'Cardio Kickboxing',
        description: 'High-energy martial arts-inspired workout',
        url: 'https://example.com/cardio-kickboxing',
      ),
      Workout(
        id: 'w6',
        name: 'Zumba',
        description: 'Dance fitness program',
        url: 'https://example.com/zumba',
      ),
      Workout(
        id: 'w7',
        name: 'Spinning',
        description: 'Indoor cycling workout',
        url: 'https://example.com/spinning',
      ),
      Workout(
        id: 'w8',
        name: 'CrossFit',
        description: 'High-intensity functional training',
        url: 'https://example.com/crossfit',
      ),
      Workout(
        id: 'w9',
        name: 'Barre',
        description: 'Ballet-inspired fitness class',
        url: 'https://example.com/barre',
      ),
      Workout(
        id: 'w10',
        name: 'TRX Training',
        description: 'Suspension training workout',
        url: 'https://example.com/trx',
      ),
      Workout(
        id: 'w11',
        name: 'Boxing',
        description: 'Cardiovascular boxing workout',
        url: 'https://example.com/boxing',
      ),
      Workout(
        id: 'w12',
        name: 'Swimming',
        description: 'Full-body aquatic workout',
        url: 'https://example.com/swimming',
      ),
      Workout(
        id: 'w13',
        name: 'Running',
        description: 'Outdoor or treadmill running program',
        url: 'https://example.com/running',
      ),
      Workout(
        id: 'w14',
        name: 'Tai Chi',
        description: 'Gentle Chinese martial art and meditation',
        url: 'https://example.com/tai-chi',
      ),
      Workout(
        id: 'w15',
        name: 'Functional Training',
        description: 'Exercises that mimic everyday movements',
        url: 'https://example.com/functional-training',
      ),
    ];
  }

  Future<Workout> getWorkoutDetails(String id) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));

    final workouts = await getWorkouts();
    return workouts.firstWhere(
          (workout) => workout.id == id,
      orElse: () => Workout(
        id: id,
        name: 'Unknown Workout',
        description: 'No description available',
        url: 'https://example.com/unknown',
      ),
    );
  }
}