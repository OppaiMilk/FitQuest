import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/core/utils/coach_workout_parser.dart';
import 'package:calories_tracking/features/book_coaches/models/coach.dart';
import 'package:calories_tracking/features/book_coaches/screens/coach_schedule_screen.dart';
import 'package:calories_tracking/features/user_feedback/user_feedback_screen.dart';
import 'package:calories_tracking/features/book_coaches/widgets/custom_button.dart';
import 'package:calories_tracking/features/book_coaches/widgets/square_info_card.dart';
import 'package:calories_tracking/features/book_coaches/widgets/workout_card.dart';
import 'package:calories_tracking/features/workouts/models/workout.dart';

class CoachDetailsScreen extends StatefulWidget {
  final Coach coach;
  final List<Workout> allWorkouts;

  const CoachDetailsScreen({
    Key? key,
    required this.coach,
    required this.allWorkouts,
  }) : super(key: key);

  @override
  _CoachDetailsScreenState createState() => _CoachDetailsScreenState();
}

class _CoachDetailsScreenState extends State<CoachDetailsScreen> {
  late Future<Map<String, dynamic>> _coachWithWorkoutsFuture;

  @override
  void initState() {
    super.initState();
    _coachWithWorkoutsFuture = CoachWorkoutParser.parseCoachWithWorkouts(
      widget.coach,
      widget.allWorkouts,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Coach Details',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                );
              },
              child: const Text(
                'Rate',
                style: TextStyle(
                  color: AppTheme.tertiaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _coachWithWorkoutsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final coach = snapshot.data!['coach'] as Coach;
            final workouts = snapshot.data!['workouts'] as List<Workout>;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(coach),
                  const SizedBox(height: 16),
                  _buildCoachInfo(coach),
                  const SizedBox(height: 16),
                  _buildInfoCards(context, coach),
                  const SizedBox(height: 24),
                  _buildRecentWorkouts(workouts),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader(Coach coach) {
    return Center(
      child: CircleAvatar(
        backgroundColor: AppTheme.secondaryColor,
        radius: 70,
        child: ClipOval(
          child: Image.network(
            coach.profileUrl,
            width: 140,
            height: 140,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.person,
                size: 70,
                color: AppTheme.primaryColor,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCoachInfo(Coach coach) {
    return Center(
      child: Column(
        children: [
          Text(
            coach.name,
            style: const TextStyle(
              color: AppTheme.tertiaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            coach.email,
            style: const TextStyle(
              color: AppTheme.secondaryTextColor,
              fontSize: 16,
            ),
          ),
          Text(
            coach.location,
            style: const TextStyle(
              color: AppTheme.secondaryTextColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context, Coach coach) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        color: AppTheme.secondaryColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  _buildSquareInfoCard('${coach.yearsOfExperience}', 'Years of\nExperience'),
                  const SizedBox(width: 8),
                  _buildSquareInfoCard('${coach.rating}', 'User\nRating'),
                  const SizedBox(width: 8),
                  _buildSquareInfoCard('${coach.completedSessions}', 'Completed\nSessions'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'Message',
                      backgroundColor: AppTheme.tertiaryColor,
                      textColor: AppTheme.tertiaryTextColor,
                      onPressed: () {
                        // TODO: Implement message functionality
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      label: 'Book',
                      backgroundColor: AppTheme.primaryColor,
                      textColor: AppTheme.primaryTextColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoachScheduleScreen(coachId: coach.id),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareInfoCard(String value, String label) {
    return Expanded(
      child: SquareInfoCard(
        value: value,
        label: label,
        backgroundColor: AppTheme.tertiaryColor,
        textColor: AppTheme.tertiaryTextColor,
      ),
    );
  }

  Widget _buildRecentWorkouts(List<Workout> workouts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Workouts',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: workouts.length,
          itemBuilder: (context, index) => WorkoutCard(
            workoutName: workouts[index].name,
            backgroundColor: AppTheme.secondaryColor,
            textColor: AppTheme.primaryTextColor,
            gradientColor: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }
}