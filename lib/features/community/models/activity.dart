import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String title;
  final DateTime timestamp;

  Activity({
    required this.id,
    required this.title,
    required this.timestamp,
  });

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Activity(
      id: doc.id,
      title: data['title'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
