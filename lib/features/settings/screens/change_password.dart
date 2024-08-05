import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset link sent! Check your email.'),
      ),
    );
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message ?? 'An error occurred'),
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
            'Change Password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter email and a password reset link will be sent.'),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _emailController,
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
              onPressed: passwordReset,
              color: AppTheme.primaryColor,
              textColor: AppTheme.primaryTextColor,
              child: const Text('Reset Password'),
            )
          ],
        ));
  }
}
