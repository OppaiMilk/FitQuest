import 'package:calories_tracking/core/utils/time_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/user_main/screens/user_main_screen.dart';
import 'package:calories_tracking/features/user_main/bloc/quest_bloc.dart';
import 'package:calories_tracking/features/user_main/bloc/user_bloc.dart';
import 'package:calories_tracking/features/user_main/repositories/quest_repository.dart';
import 'package:calories_tracking/features/user_main/repositories/user_repository.dart';

void main() {
  final malaysiaTime = TimeParser.getMalaysiaTime();
  print('App started at (Malaysia Time - MYT):');
  print(TimeParser.formatDateTime(malaysiaTime));

  runApp(const MyApp());
}

String _formatDateTime(DateTime dateTime) {
  return '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} '
      '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}.${_threeDigits(dateTime.millisecond)}';
}

String _twoDigits(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}

String _threeDigits(int n) {
  if (n >= 100) return "$n";
  if (n >= 10) return "0$n";
  return "00$n";
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