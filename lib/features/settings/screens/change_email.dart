import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangeEmail extends StatefulWidget {
  ChangeEmail({super.key});

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final _newEmailController = TextEditingController();

  @override
  void dispose() {
    _newEmailController.dispose();
    super.dispose();
  }

  Future<void> changeEmail(String newEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email updated successfully'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user is currently signed in'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already in use by another account.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'requires-recent-login':
          errorMessage =
              'This operation is sensitive and requires recent authentication. Please log in again before retrying.';
          break;
        default:
          errorMessage = 'An error occurred while updating email: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          title: const Text(
            'Change Email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Enter your email and a verification email will be sent to you.'),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _newEmailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Email',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () {
                if (_newEmailController.text.isNotEmpty) {
                  changeEmail(_newEmailController.text.trim());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a new email'),
                    ),
                  );
                }
              },
              color: AppTheme.primaryColor,
              textColor: AppTheme.primaryTextColor,
              child: const Text('Update Email'),
            )
          ],
        ));
  }
}
