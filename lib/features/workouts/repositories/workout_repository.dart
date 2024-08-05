import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calories_tracking/features/workouts/models/workout.dart';

class WorkoutRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Workout>> getWorkouts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('workouts').get();
      return querySnapshot.docs.map((doc) {
        return Workout(
          id: doc.id,
          name: doc['name'],
          url: doc['url'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching workouts: $e');
      return [];
    }
  }

  Future<Workout> getWorkoutDetails(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('workouts').doc(id).get();
      if (doc.exists) {
        return Workout(
          id: doc.id,
          name: doc['name'],
          url: doc['url'],
        );
      } else {
        return Workout(
          id: id,
          name: 'Unknown Workout',
          url: 'https://example.com/unknown',
        );
      }
    } catch (e) {
      print('Error fetching workout details: $e');
      return Workout(
        id: id,
        name: 'Error',
        url: 'https://example.com/error',
      );
    }
  }
}
