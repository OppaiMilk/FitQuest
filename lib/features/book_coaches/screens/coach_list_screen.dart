import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/bloc/book_coaches_bloc.dart';
import 'package:calories_tracking/features/book_coaches/bloc/workout_bloc.dart';
import 'package:calories_tracking/features/book_coaches/repositories/coach_repository.dart';
import 'package:calories_tracking/features/book_coaches/screens/coach_details_screen.dart';
import 'package:calories_tracking/features/book_coaches/widgets/coach_card.dart';
import 'package:calories_tracking/features/book_coaches/widgets/coach_grid.dart';
import 'package:calories_tracking/features/book_coaches/widgets/search_field.dart';
import 'package:calories_tracking/features/workouts/repositories/workout_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachListScreen extends StatelessWidget {
  final CoachRepository coachRepository;
  final WorkoutRepository workoutRepository;

  const CoachListScreen({
    super.key,
    required this.coachRepository,
    required this.workoutRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              BookCoachesBloc(coachRepository)..add(LoadCoaches()),
        ),
        BlocProvider(
          create: (context) =>
              WorkoutBloc(workoutRepository)..add(LoadWorkouts()),
        ),
      ],
      child: const _CoachListView(),
    );
  }
}

class _CoachListView extends StatefulWidget {
  const _CoachListView();

  @override
  _CoachListViewState createState() => _CoachListViewState();
}

class _CoachListViewState extends State<_CoachListView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Coaches',
            style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          SearchField(
            onChanged: (value) =>
                setState(() => _searchQuery = value.toLowerCase()),
            backgroundColor: AppTheme.tertiaryColor,
            textColor: AppTheme.tertiaryTextColor,
          ),
          Expanded(
            child: BlocBuilder<BookCoachesBloc, BookCoachesState>(
              builder: (context, coachState) {
                return BlocBuilder<WorkoutBloc, WorkoutState>(
                  builder: (context, workoutState) {
                    return _buildContent(context, coachState, workoutState);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, BookCoachesState coachState,
      WorkoutState workoutState) {
    if (coachState is BookCoachesLoading || workoutState is WorkoutLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor));
    } else if (coachState is BookCoachesLoaded &&
        workoutState is WorkoutLoaded) {
      return CoachGrid(
        coaches: coachState.coaches,
        searchQuery: _searchQuery,
        coachBuilder: (coach) => CoachCard(
          coach: coach,
          onTap: (context, coach) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoachDetailsScreen(
                  coach: coach,
                  allWorkouts: workoutState.workouts,
                ),
              ),
            );
          },
          backgroundColor: AppTheme.secondaryColor,
          textColor: AppTheme.primaryTextColor,
          gradientColor: AppTheme.primaryColor,
          starColor: AppTheme.starColor,
        ),
      );
    } else if (coachState is BookCoachesError) {
      return Center(
        child: Text(coachState.message,
            style: const TextStyle(color: AppTheme.primaryColor, fontSize: 16)),
      );
    } else if (workoutState is WorkoutError) {
      return Center(
        child: Text(workoutState.message,
            style: const TextStyle(color: AppTheme.primaryColor, fontSize: 16)),
      );
    } else {
      return const Center(
        child: Text('No coaches or workouts available',
            style: TextStyle(color: AppTheme.tertiaryTextColor, fontSize: 16)),
      );
    }
  }
}
