import 'package:calories_tracking/features/community/widgets/activity_item.dart';
import 'package:calories_tracking/features/community/widgets/go_to_coaches_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/screens/user_coach_list_screen.dart';
import 'package:calories_tracking/features/community/bloc/activity_bloc.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building CommunityScreen');
    context.read<ActivityBloc>().add(LoadActivities());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContactCoachesCard(
              onTap: () => navigateToCoachListScreen(context),
            ),
            const SizedBox(height: 20),
            buildRecentActivity(context),
          ],
        ),
      ),
    );
  }

  Widget buildRecentActivity(BuildContext context) {
    return Expanded(
      child: Column(
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
          BlocConsumer<ActivityBloc, ActivityState>(
            listener: (context, state) {
              if (state is ActivityError) {
                print('ActivityError: ${state.message}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            },
            builder: (context, state) {
              print('Current ActivityBloc state: $state');
              if (state is ActivityInitial || state is ActivityLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ActivitiesLoaded) {
                print('ActivitiesLoaded state, activities count: ${state.activities.length}');
                if (state.activities.isEmpty) {
                  return const Center(child: Text('No activities available'));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.activities.length,
                    itemBuilder: (context, index) {
                      print('Building ActivityCard for index $index');
                      return ActivityCard(activity: state.activities[index]);
                    },
                  ),
                );
              } else if (state is ActivityError) {
                print('ActivityError state: ${state.message}');
                return Center(child: Text('Error: ${state.message}'));
              } else {
                print('Unknown state: $state');
                return const Center(child: Text('Unknown state'));
              }
            },
          ),
        ],
      ),
    );
  }

  void navigateToCoachListScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CoachListScreen(),
      ),
    );
  }
}
