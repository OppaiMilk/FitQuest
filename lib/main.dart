import 'package:calories_tracking/features/screens/coach_register.dart';
import 'package:flutter/material.dart';

import 'features/screens/coach_homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CoachRegister(),
    );
  }
}
