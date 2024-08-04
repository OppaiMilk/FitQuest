import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/repositories/coach_repository.dart';
import 'package:calories_tracking/features/book_coaches/screens/user_coach_list_screen.dart';
import 'package:calories_tracking/features/community/widgets/activity_item.dart';
import 'package:calories_tracking/features/community/widgets/go_to_coaches_card.dart';
import 'package:calories_tracking/features/locations/repositories/location_repository.dart';
import 'package:calories_tracking/features/workouts/repositories/workout_repository.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContactCoachesCard(
                onTap: () => navigateToCoachListScreen(context),
              ),
              const SizedBox(height: 20),
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            color: AppTheme.tertiaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        ActivityItem(
            activity: 'John just reached 10th place on the leaderboard'),
        ActivityItem(activity: 'Sam just reached their 100th day streak'),
        ActivityItem(
            activity: 'Alex just completed 2 quests and got 10 points'),
        ActivityItem(
            activity: 'Derek just reached 11th place on the leaderboard'),
        ActivityItem(activity: 'Jaiden just reached their 30th day streak'),
        ActivityItem(
            activity: 'John just reached 10th place on the leaderboard'),
        ActivityItem(activity: 'Sam just reached their 100th day streak'),
        ActivityItem(
            activity: 'Alex just completed 2 quests and got 10 points'),
        ActivityItem(
            activity: 'Derek just reached 11th place on the leaderboard'),
        ActivityItem(activity: 'Jaiden just reached their 30th day streak'),
      ],
    );
  }

  void navigateToCoachListScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(
              value: RepositoryProvider.of<CoachRepository>(context),
            ),
            RepositoryProvider.value(
              value: RepositoryProvider.of<WorkoutRepository>(context),
            ),
            RepositoryProvider.value(
              value: RepositoryProvider.of<LocationRepository>(context),
            ),
          ],
          child: const CoachListScreen(),
        ),
      ),
    );
  }
}
