import 'package:flutter/material.dart';

class AdminFeedbackScreen extends StatelessWidget {
  const AdminFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return const FeedbackItem();
      },
    );
  }
}

class FeedbackItem extends StatelessWidget {
  const FeedbackItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
          ),
          title: const Text('Jane Doe'),
          subtitle: const Column(
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
              const Text('5', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}