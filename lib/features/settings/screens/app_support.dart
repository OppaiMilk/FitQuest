import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/settings/screens/app_feedback.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tertiaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Support',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildContactItem(
            icon: Icons.phone,
            title: 'Our Phone Number',
            content: '012 345 6789',
          ),
          _buildContactItem(
            icon: Icons.email,
            title: 'Email Us At',
            content: 'fitquest@gmail.com',
          ),
          _buildFeedbackButton(context),
          _buildFAQSection(),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AppFeedbackScreen()));
        },
        child: const Text(
          'Send Us Feedback',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'FAQs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildFAQItem('Who?', 'This is the answer to FAQ 1.'),
          _buildFAQItem('What?', 'This is the answer to FAQ 2.'),
          _buildFAQItem('Where?', 'This is the answer to FAQ 3.'),
          _buildFAQItem('When?', 'This is the answer to FAQ 4.'),
          _buildFAQItem('How?', 'This is the answer to FAQ 5.'),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(answer, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}
