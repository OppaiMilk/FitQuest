import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CoachRegister extends StatelessWidget {
  const CoachRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.tertiaryColor,
        body: Padding(
            padding: const EdgeInsets.all(40),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    'Registration',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Please fill in your details',
                    style: TextStyle(color: AppTheme.secondaryTextColor),
                  ),
                  const SizedBox(height: 30),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.visibility),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.visibility),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.upload_file,
                              size: 50, color: Colors.grey),
                          const SizedBox(height: 10),
                          const Text(
                            'Drag and Drop File Here or',
                            style: TextStyle(color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle file selection
                            },
                            child: const Text(
                              'Choose File',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('register success');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: AppTheme.primaryTextColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('sign in');
                          },
                          child: const Text(
                            'Already Have an Account? Sign In Instead',
                            style:
                                TextStyle(color: AppTheme.secondaryTextColor),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            print('user register');
                          },
                          child: const Text(
                            'Want to Register as a User? Click Here',
                            style:
                                TextStyle(color: AppTheme.secondaryTextColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]))));
  }
}
