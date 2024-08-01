import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/screens/coach_homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitQuest',
      theme: AppTheme.lightTheme,
      home: const CoachHomePage(),
    );
  }
}
