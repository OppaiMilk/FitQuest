import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calories_tracking/features/user_main/screens/user_main_screen.dart';
import 'package:calories_tracking/features/user_main/bloc/quest_bloc.dart';
import 'package:calories_tracking/features/user_main/bloc/user_bloc.dart';
import 'package:calories_tracking/features/user_main/repositories/quest_repository.dart';
import 'package:calories_tracking/features/user_main/repositories/user_repository.dart';
import 'package:calories_tracking/features/book_coaches/repositories/coach_repository.dart';
import 'package:calories_tracking/features/workouts/repositories/workout_repository.dart';
import 'package:calories_tracking/features/book_coaches/repositories/booking_repository.dart';
import 'package:calories_tracking/features/locations/repositories/location_repository.dart';
import 'package:calories_tracking/features/book_coaches/bloc/book_coaches_bloc.dart';
import 'package:calories_tracking/features/workouts/bloc/workout_bloc.dart';
import 'package:calories_tracking/features/locations/bloc/location_bloc.dart';
import 'package:calories_tracking/features/community/repositories/activity_repository.dart';
import 'package:calories_tracking/features/community/bloc/activity_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Uncomment the next line to populate users (use only once)
  // await populateUsers(); //TODO remove this

  runApp(const MyApp());
}

Future<void> populateUsers() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Map<String, dynamic>> users = [
    {'name': 'John Doe', 'currentStreak': 5, 'totalPoints': 1000, 'completedSessions': 20, 'email': 'john@example.com', 'location': 'New York', 'profileUrl': 'https://example.com/john.jpg'},
    {'name': 'Jane Smith', 'currentStreak': 10, 'totalPoints': 1500, 'completedSessions': 30, 'email': 'jane@example.com', 'location': 'Los Angeles', 'profileUrl': 'https://example.com/jane.jpg'},
    {'name': 'Mike Johnson', 'currentStreak': 3, 'totalPoints': 800, 'completedSessions': 15, 'email': 'mike@example.com', 'location': 'Chicago', 'profileUrl': 'https://example.com/mike.jpg'},
    {'name': 'Emily Brown', 'currentStreak': 7, 'totalPoints': 1200, 'completedSessions': 25, 'email': 'emily@example.com', 'location': 'Houston', 'profileUrl': 'https://example.com/emily.jpg'},
    {'name': 'David Lee', 'currentStreak': 15, 'totalPoints': 2000, 'completedSessions': 40, 'email': 'david@example.com', 'location': 'Phoenix', 'profileUrl': 'https://example.com/david.jpg'},
    {'name': 'Sarah Wilson', 'currentStreak': 8, 'totalPoints': 1300, 'completedSessions': 28, 'email': 'sarah@example.com', 'location': 'Philadelphia', 'profileUrl': 'https://example.com/sarah.jpg'},
    {'name': 'Tom Anderson', 'currentStreak': 4, 'totalPoints': 900, 'completedSessions': 18, 'email': 'tom@example.com', 'location': 'San Antonio', 'profileUrl': 'https://example.com/tom.jpg'},
    {'name': 'Lisa Davis', 'currentStreak': 12, 'totalPoints': 1700, 'completedSessions': 35, 'email': 'lisa@example.com', 'location': 'San Diego', 'profileUrl': 'https://example.com/lisa.jpg'},
    {'name': 'Mark Taylor', 'currentStreak': 6, 'totalPoints': 1100, 'completedSessions': 22, 'email': 'mark@example.com', 'location': 'Dallas', 'profileUrl': 'https://example.com/mark.jpg'},
    {'name': 'Amy Martinez', 'currentStreak': 9, 'totalPoints': 1400, 'completedSessions': 29, 'email': 'amy@example.com', 'location': 'San Jose', 'profileUrl': 'https://example.com/amy.jpg'},
    {'name': 'Chris White', 'currentStreak': 11, 'totalPoints': 1600, 'completedSessions': 32, 'email': 'chris@example.com', 'location': 'Austin', 'profileUrl': 'https://example.com/chris.jpg'},
    {'name': 'Karen Lewis', 'currentStreak': 2, 'totalPoints': 700, 'completedSessions': 14, 'email': 'karen@example.com', 'location': 'Jacksonville', 'profileUrl': 'https://example.com/karen.jpg'},
    {'name': 'Steven Hall', 'currentStreak': 14, 'totalPoints': 1900, 'completedSessions': 38, 'email': 'steven@example.com', 'location': 'San Francisco', 'profileUrl': 'https://example.com/steven.jpg'},
    {'name': 'Nancy Clark', 'currentStreak': 7, 'totalPoints': 1200, 'completedSessions': 25, 'email': 'nancy@example.com', 'location': 'Indianapolis', 'profileUrl': 'https://example.com/nancy.jpg'},
    {'name': 'Paul Rodriguez', 'currentStreak': 5, 'totalPoints': 1000, 'completedSessions': 20, 'email': 'paul@example.com', 'location': 'Columbus', 'profileUrl': 'https://example.com/paul.jpg'},
    {'name': 'Laura Lopez', 'currentStreak': 13, 'totalPoints': 1800, 'completedSessions': 36, 'email': 'laura@example.com', 'location': 'Fort Worth', 'profileUrl': 'https://example.com/laura.jpg'},
    {'name': 'Kevin Hill', 'currentStreak': 6, 'totalPoints': 1100, 'completedSessions': 22, 'email': 'kevin@example.com', 'location': 'Charlotte', 'profileUrl': 'https://example.com/kevin.jpg'},
    {'name': 'Rachel Scott', 'currentStreak': 8, 'totalPoints': 1300, 'completedSessions': 28, 'email': 'rachel@example.com', 'location': 'Detroit', 'profileUrl': 'https://example.com/rachel.jpg'},
    {'name': 'Daniel Green', 'currentStreak': 4, 'totalPoints': 900, 'completedSessions': 18, 'email': 'daniel@example.com', 'location': 'El Paso', 'profileUrl': 'https://example.com/daniel.jpg'},
    {'name': 'Michelle Adams', 'currentStreak': 10, 'totalPoints': 1500, 'completedSessions': 30, 'email': 'michelle@example.com', 'location': 'Memphis', 'profileUrl': 'https://example.com/michelle.jpg'},
  ];

  for (var user in users) {
    try {
      await _firestore.collection('users').add({
        ...user,
        'lastCompletedDate': Timestamp.now(),
        'lastQuestUpdate': Timestamp.now(),
        'completedQuestIds': [],
      });
      print('Added user: ${user['name']}');
    } catch (e) {
      print('Error adding user ${user['name']}: $e');
    }
  }

  print('Finished populating users');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CoachRepository>(
          create: (context) => CoachRepository(),
        ),
        RepositoryProvider<WorkoutRepository>(
          create: (context) => WorkoutRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider<QuestRepository>(
          create: (context) => QuestRepository(),
        ),
        RepositoryProvider<BookingRepository>(
          create: (context) => BookingRepository(),
        ),
        RepositoryProvider<LocationRepository>(
          create: (context) => LocationRepository(),
        ),
        RepositoryProvider<ActivityRepository>(
          create: (context) => ActivityRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
            BookCoachesBloc(context.read<CoachRepository>())
              ..add(LoadCoaches()),
          ),
          BlocProvider(
            create: (context) => WorkoutBloc(context.read<WorkoutRepository>())
              ..add(LoadWorkouts()),
          ),
          BlocProvider(
            create: (context) =>
            LocationBloc(context.read<LocationRepository>())
              ..add(LoadLocations()),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(context.read<UserRepository>())
              ..add(
                  FetchUser('U1')), //TODO integrate login here, pass in user id
          ),
          BlocProvider<QuestBloc>(
            create: (context) => QuestBloc(
              context.read<QuestRepository>(),
              context.read<UserBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) => ActivityBloc(
              RepositoryProvider.of<ActivityRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FitQuest',
          theme: AppTheme.lightTheme,
          home: const UserMainScreen(),
        ),
      ),
    );
  }
}