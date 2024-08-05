import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calories_tracking/features/book_coaches/models/coach.dart';

class CoachRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Coach>> getCoaches() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('coaches').get();
      return querySnapshot.docs.map((doc) {
        return Coach(
          id: doc.id,
          name: doc['name'],
          numOfRatings: doc['numOfRatings'],
          rating: doc['rating'].toDouble(),
          email: doc['email'],
          location: doc['location'],
          yearsOfExperience: doc['yearsOfExperience'],
          completedSessions: doc['completedSessions'],
          workoutIds: List<String>.from(doc['workoutIds']),
          profileUrl: doc['profileUrl'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching coaches: $e');
      return [];
    }
  }



  Future<Coach> getCoachDetails(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('coaches').doc(id).get();
      if (doc.exists) {
        return Coach(
          id: doc.id,
          name: doc['name'],
          numOfRatings: doc['numOfRatings'],
          rating: doc['rating'].toDouble(),
          email: doc['email'],
          location: doc['location'],
          yearsOfExperience: doc['yearsOfExperience'],
          completedSessions: doc['completedSessions'],
          workoutIds: List<String>.from(doc['workoutIds']),
          profileUrl: doc['profileUrl'],
        );
      } else {
        return Coach(
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
        );
      }
    } catch (e) {
      print('Error fetching coach details: $e');
      return Coach(
        id: id,
        name: 'Error',
        numOfRatings: 0,
        rating: 0.0,
        email: 'error@example.com',
        location: 'Error Location',
        yearsOfExperience: 0,
        completedSessions: 0,
        workoutIds: [],
        profileUrl: 'https://via.placeholder.com/150',
      );
    }
  }
}
