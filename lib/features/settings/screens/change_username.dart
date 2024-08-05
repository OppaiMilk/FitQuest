import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangeUsername extends StatefulWidget {
  ChangeUsername({super.key});

  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final _usernameController = TextEditingController();

  Future<void> updateDisplayName(String newName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName);

        // Refresh the user to get the updated information
        await user.reload();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in')),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update username: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          title: const Text(
            'Change Username',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter your new username.'),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Username',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () {
                if (_usernameController.text.isNotEmpty) {
                  updateDisplayName(_usernameController.text.trim());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter a valid username.')),
                  );
                }
              },
              color: AppTheme.primaryColor,
              textColor: AppTheme.primaryTextColor,
              child: const Text('Update Username'),
            )
          ],
        ));
  }
}
