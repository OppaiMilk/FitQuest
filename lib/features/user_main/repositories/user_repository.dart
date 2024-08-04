import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calories_tracking/features/user_main/models/user.dart';
import 'package:calories_tracking/core/utils/time_parser.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User> getUserById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();
      if (doc.exists) {
        return User(
          id: doc.id,
          name: doc['name'] ?? 'Unknown User',
          currentStreak: doc['currentStreak'],
          lastCompletedDate: TimeParser.convertUTCToMalaysiaTime(doc['lastCompletedDate'] as Timestamp?),
          totalPoints: doc['totalPoints'],
          completedSessions: doc['completedSessions'],
          email: doc['email'],
          location: doc['location'],
          completedQuestIds: List<String>.from(doc['completedQuestIds']),
        );
      } else {
        return User(
          id: id,
          name: 'Unknown User',
          currentStreak: 0,
          lastCompletedDate: TimeParser.getMalaysiaTime(),
          totalPoints: 0,
          completedSessions: 0,
          email: 'unknown@example.com',
          location: 'Unknown',
          completedQuestIds: [],
        );
      }
    } catch (e) {
      print('Error fetching user: $e');
      return User(
        id: id,
        name: 'Error',
        currentStreak: 0,
        lastCompletedDate: TimeParser.getMalaysiaTime(),
        totalPoints: 0,
        completedSessions: 0,
        email: 'error@example.com',
        location: 'Error',
        completedQuestIds: [],
      );
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final utcLastCompletedDate = TimeParser.convertMalaysiaTimeToUTC(user.lastCompletedDate);
      await _firestore.collection('users').doc(user.id).set({
        'name': user.name,
        'currentStreak': user.currentStreak,
        'lastCompletedDate': Timestamp.fromDate(utcLastCompletedDate),
        'totalPoints': user.totalPoints,
        'completedSessions': user.completedSessions,
        'email': user.email,
        'location': user.location,
        'completedQuestIds': user.completedQuestIds,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating user: $e');
    }
  }
}
