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
          lastQuestUpdate: TimeParser.convertUTCToMalaysiaTime(doc['lastQuestUpdate'] as Timestamp?),
          totalPoints: doc['totalPoints'],
          completedSessions: doc['completedSessions'],
          email: doc['email'],
          location: doc['location'],
          completedQuestIds: List<String>.from(doc['completedQuestIds']),
          profileUrl: doc['profileUrl'],
        );
      } else {
        final now = TimeParser.getMalaysiaTime();
        return User(
          id: id,
          name: 'Unknown User',
          currentStreak: 0,
          lastCompletedDate: now,
          lastQuestUpdate: now,
          totalPoints: 0,
          completedSessions: 0,
          email: 'unknown@example.com',
          location: 'Unknown',
          completedQuestIds: [],
          profileUrl: 'Unknown',
        );
      }
    } catch (e) {
      print('Error fetching user: $e');
      final now = TimeParser.getMalaysiaTime();
      return User(
        id: id,
        name: 'Error',
        currentStreak: 0,
        lastCompletedDate: now,
        lastQuestUpdate: now,
        totalPoints: 0,
        completedSessions: 0,
        email: 'error@example.com',
        location: 'Error',
        completedQuestIds: [],
        profileUrl: 'Error',
      );
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final utcLastCompletedDate = TimeParser.convertMalaysiaTimeToUTC(user.lastCompletedDate);
      final utcLastQuestUpdate = TimeParser.convertMalaysiaTimeToUTC(user.lastQuestUpdate);
      await _firestore.collection('users').doc(user.id).set({
        'name': user.name,
        'currentStreak': user.currentStreak,
        'lastCompletedDate': Timestamp.fromDate(utcLastCompletedDate),
        'lastQuestUpdate': Timestamp.fromDate(utcLastQuestUpdate),
        'totalPoints': user.totalPoints,
        'completedSessions': user.completedSessions,
        'email': user.email,
        'location': user.location,
        'completedQuestIds': user.completedQuestIds,
        'profileUrl': user.profileUrl,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  Future<void> submitCoachRating(String coachId, double rating) async {
    try {
      final now = TimeParser.getMalaysiaTime();
      final utcNow = TimeParser.convertMalaysiaTimeToUTC(now);

      DocumentReference coachRef = _firestore.collection('coaches').doc(coachId);
      DocumentSnapshot coachDoc = await coachRef.get();

      if (coachDoc.exists) {
        Map<String, dynamic> coachData = coachDoc.data() as Map<String, dynamic>;

        int totalRatings = (coachData['totalRatings'] ?? 0) + 1;
        double averageRating = ((coachData['rating'] ?? 0.0) * (totalRatings - 1) + rating) / totalRatings;

        await coachRef.update({
          'rating': averageRating, // Update the average rating
          'totalRatings': totalRatings,    // Update the total ratings count
        });

        await coachRef.collection('ratings').add({
          'rating': rating,
          'date': Timestamp.fromDate(utcNow),
        });

        print('Coach rating submitted successfully');
      } else {
        throw Exception('Coach not found');
      }
    } catch (e) {
      print('Error submitting coach rating: $e');
      rethrow;
    }
  }
}
