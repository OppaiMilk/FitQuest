import 'package:calories_tracking/features/community/bloc/activity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/bloc/book_coaches_bloc.dart';
import 'package:calories_tracking/features/book_coaches/screens/user_coach_details_screen.dart';
import 'package:calories_tracking/features/book_coaches/widgets/coach_card.dart';
import 'package:calories_tracking/features/book_coaches/widgets/coach_grid.dart';
import 'package:calories_tracking/features/book_coaches/widgets/search_field.dart';

class CoachListScreen extends StatelessWidget {
  const CoachListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CoachListView();
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
          onPressed: () {
            context.read<ActivityBloc>().add(LoadActivities());
            Navigator.pop(context);
          },
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
              builder: (context, state) {
                return _buildContent(context, state);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, BookCoachesState state) {
    if (state is BookCoachesLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor));
    } else if (state is BookCoachesLoaded) {
      return CoachGrid(
        coaches: state.coaches,
        searchQuery: _searchQuery,
        coachBuilder: (coach) => CoachCard(
          coach: coach,
          onTap: (context, coach) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoachDetailsScreen(coachId: coach.id),
              ),
            );
          },
          backgroundColor: AppTheme.secondaryColor,
          textColor: AppTheme.primaryTextColor,
          gradientColor: AppTheme.primaryColor,
          starColor: AppTheme.starColor,
        ),
      );
    } else if (state is BookCoachesError) {
      return Center(
        child: Text(state.message,
            style: const TextStyle(color: AppTheme.primaryColor, fontSize: 16)),
      );
    } else {
      return const Center(
        child: Text('No coaches available',
            style: TextStyle(color: AppTheme.tertiaryTextColor, fontSize: 16)),
      );
    }
  }
}