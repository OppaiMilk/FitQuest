import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/screens/user_coach_list_screen.dart';
import 'package:calories_tracking/features/community/widgets/activity_item.dart';
import 'package:calories_tracking/features/community/widgets/go_to_coaches_card.dart';
import 'package:calories_tracking/features/community/bloc/activity_bloc.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityBloc>().add(LoadActivities());
    });

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
              buildRecentActivity(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecentActivity(BuildContext context) {
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
        BlocConsumer<ActivityBloc, ActivityState>(
          listener: (context, state) {
            if (state is ActivityError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            print('Current ActivityBloc state: $state');
            if (state is ActivityInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ActivityLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ActivitiesLoaded) {
              if (state.activities.isEmpty) {
                return const Center(child: Text('No activities available'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.activities.length,
                itemBuilder: (context, index) {
                  return ActivityItem(activity: state.activities[index].title);
                },
              );
            } else if (state is ActivityError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ],
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