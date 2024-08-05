import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FeedbackManageScreen extends StatefulWidget {
  const FeedbackManageScreen({super.key});

  @override
  _FeedbackManageScreenState createState() => _FeedbackManageScreenState();
}

class _FeedbackManageScreenState extends State<FeedbackManageScreen> {
  late Future<List<Map<String, dynamic>>> _feedback;

  Future<List<Map<String, dynamic>>> _getFeedback() async {
    try {

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('feedback')
          .get();

      List<Map<String, dynamic>> feedback = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return feedback;
    } catch (e) {
      print('Error getting feedback: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _feedback = _getFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _feedback,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading users'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No feedback found'));
              } else {
                final feedback = snapshot.data!;
                return ListView.builder(
                  itemCount: feedback.length,
                  itemBuilder: (context, index) {
                    final feedbacks = feedback[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(convertTimestampToString(feedbacks['timestamp'])??'No Date'),
                              SizedBox(height: 5),
                              Text(feedbacks['message'] ?? 'No Name'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),

      ],
    );
  }

  String convertTimestampToString(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    // Format the DateTime into a readable string
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    return formattedDate;
  }
}
