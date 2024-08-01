import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/bloc/book_coaches_bloc.dart';
import 'package:calories_tracking/features/book_coaches/repositories/coach_repository.dart';
import 'package:calories_tracking/features/book_coaches/screens/coach_list_screen.dart';
import 'package:calories_tracking/features/workouts/repositories/workout_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BookCoachesBloc(CoachRepository())),
        BlocProvider(create: (context) => WorkoutBloc(WorkoutRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FitQuest',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => CoachListScreen(
            coachRepository: CoachRepository(),
            workoutRepository: WorkoutRepository(),
          ),
        },
      ),
    );
  }
}