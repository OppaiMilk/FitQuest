import 'package:calories_tracking/features/coach_main/bloc/booking_bloc.dart';
import 'package:calories_tracking/features/coach_main/bloc/coach_bloc.dart';
import 'package:calories_tracking/features/coach_main/screens/coach_main_screen.dart';
import 'package:calories_tracking/features/coach_main/screens/coach_user_details_screen.dart';
import 'package:calories_tracking/features/settings/screens/app_feedback.dart';
import 'package:calories_tracking/features/settings/screens/app_support.dart';
import 'package:calories_tracking/features/settings/screens/profile_settings.dart';
import 'package:calories_tracking/features/onboarding/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
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
  runApp(const MyApp());
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
          BlocProvider<CoachBloc>(
            create: (context) => CoachBloc(context.read<CoachRepository>())
              ..add(FetchCoach('C1')),
          ),
          BlocProvider<BookingBloc>(
            create: (context) => BookingBloc(
              context.read<BookingRepository>(),
              context.read<CoachBloc>(),
            )
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FitQuest',
          theme: AppTheme.lightTheme,
          home: HomePage(),
        ),
      ),
    );
  }
}