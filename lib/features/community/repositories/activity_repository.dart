import 'package:calories_tracking/features/community/models/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Activity>> getActivities() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('activities').get();
      return querySnapshot.docs.map((doc) {
        return Activity(
          id: doc.id,
          title: doc['title'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching activities: $e');
      return [];
    }
  }

  Future<Activity> getActivityDetails(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('activities').doc(id).get();
      if (doc.exists) {
        return Activity(
          id: doc.id,
          title: doc['title'],
        );
      } else {
        return Activity(
          id: id,
          title: 'Unknown Activity',
        );
      }
    } catch (e) {
      print('Error fetching activity details: $e');
      return Activity(
        id: id,
        title: 'Error',
      );
    }
  }
}