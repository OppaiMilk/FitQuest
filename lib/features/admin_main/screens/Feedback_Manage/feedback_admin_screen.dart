import 'package:flutter/material.dart';

class AdminFeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return FeedbackItem();
      },
    );
  }
}

class FeedbackItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
          ),
          title: Text('Jane Doe'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('7/30/2024 | 9:18 PM'),
              SizedBox(height: 5),
              Text('This is an example of a feedback'),
            ],
          ),
          trailing: Column(
            children: [
              Icon(Icons.star, color: Colors.grey[600]),
              Text('5', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}