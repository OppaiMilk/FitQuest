import 'package:calories_tracking/features/community/models/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calories_tracking/core/utils/time_parser.dart';

class ActivityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Activity>> getActivities() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('activities')
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs.map((doc) {
        return Activity(
          id: doc.id,
          title: doc['title'],
          timestamp: TimeParser.convertUTCToMalaysiaTime(doc['timestamp'] as Timestamp),
        );
      }).toList();
    } catch (e) {
      print('Error fetching activities: $e');
      return [];
    }
  }

  Future<Activity?> getActivityDetails(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('activities').doc(id).get();
      if (doc.exists) {
        return Activity(
          id: doc.id,
          title: doc['title'],
          timestamp: TimeParser.convertUTCToMalaysiaTime(doc['timestamp'] as Timestamp),
        );
      }
    } catch (e) {
      print('Error fetching activity details: $e');
    }
    return null;
  }

  Future<void> addActivity(String title) async {
    try {
      await _firestore.collection('activities').add({
        'title': title,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Activity added successfully: $title');
    } catch (e) {
      print('Error adding activity: $e');
      rethrow;
    }
  }
}