import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/screens/coach_list_screen.dart';
import 'package:calories_tracking/features/book_coaches/repositories/coach_repository.dart';
import 'package:calories_tracking/features/workouts/repositories/workout_repository.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      title: const Text(
        'Community',
        style: TextStyle(
          color: AppTheme.primaryTextColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactCoaches(context),
            const SizedBox(height: 20),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCoaches(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: const Text(
          'Get in Contact With Coaches Now',
          style: TextStyle(
            color: AppTheme.tertiaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.tertiaryTextColor),
        onTap: () {
          _navigateToCoachListScreen(context);
        },
      ),
    );
  }

  void _navigateToCoachListScreen(BuildContext context) {
    final coachRepository = RepositoryProvider.of<CoachRepository>(context);
    final workoutRepository = RepositoryProvider.of<WorkoutRepository>(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoachListScreen(
          coachRepository: coachRepository,
          workoutRepository: workoutRepository,
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            color: AppTheme.tertiaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildActivityItem('John just reached 10th place on the leaderboard'),
        _buildActivityItem('Sam just reached their 100th day streak'),
        _buildActivityItem('Alex just completed 2 quests and got 10 points'),
        _buildActivityItem('Derek just reached 11th place on the leaderboard'),
        _buildActivityItem('Jaiden just reached their 30th day streak'),
      ],
    );
  }

  Widget _buildActivityItem(String activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          activity,
          style: const TextStyle(
            color: AppTheme.tertiaryTextColor,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(Icons.circle_outlined, color: AppTheme.tertiaryTextColor),
      ),
    );
  }
}
