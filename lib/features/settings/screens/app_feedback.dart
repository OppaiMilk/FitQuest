import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppFeedbackScreen extends StatefulWidget {
  const AppFeedbackScreen({super.key});
  
  @override
  _AppFeedbackState createState() => _AppFeedbackState();
}

class _AppFeedbackState extends State<AppFeedbackScreen> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Feedback',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Star rating widget here
            const SizedBox(height: 20),
            const Text('Tell us more about your feedback'),
            const SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Please enter your feedback here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() {
    print('feedback sent');
  }
  
}