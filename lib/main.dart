import 'package:calories_tracking/core/utils/time_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/user_main/screens/user_main_screen.dart';
import 'package:calories_tracking/features/user_main/bloc/quest_bloc.dart';
import 'package:calories_tracking/features/user_main/bloc/user_bloc.dart';
import 'package:calories_tracking/features/user_main/repositories/quest_repository.dart';
import 'package:calories_tracking/features/user_main/repositories/user_repository.dart';

//TODO remove print statements used for terminal logging, non production purposes only
void main() {
  final malaysiaTime = TimeParser.getMalaysiaTime();
  print('App started at (Malaysia Time - MYT):');
  print(TimeParser.formatDateTime(malaysiaTime));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(UserRepository()),
        ),
        BlocProvider<QuestBloc>(
          create: (context) => QuestBloc(
            QuestRepository(),
            context.read<UserBloc>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FitQuest',
        theme: AppTheme.lightTheme,
        home: const UserMainScreen(),
      ),
    );
  }
}