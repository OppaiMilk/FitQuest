import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/book_coaches/bloc/book_coaches_bloc.dart';
import 'features/book_coaches/repositories/coach_repository.dart';
import 'features/book_coaches/screens/coach_list_screen.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FitQuest',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => CoachListScreen(coachRepository: CoachRepository()),
        },
      ),
    );
  }
}