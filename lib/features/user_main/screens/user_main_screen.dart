import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/user_main/bloc/quest_bloc.dart';
import 'package:calories_tracking/features/user_main/widgets/bottom_navigation.dart';
import 'package:calories_tracking/features/user_main/widgets/quest_section.dart';
import 'package:calories_tracking/features/user_main/widgets/streak_card.dart';

class UserMainScreen extends StatelessWidget {
  const UserMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tertiaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'John Doe',
              style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppTheme.primaryTextColor),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<QuestBloc, QuestState>(
        builder: (context, state) {
          if (state is QuestInitial) {
            context.read<QuestBloc>().add(FetchQuests());
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuestLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuestLoaded) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(18),
                  sliver: SliverToBoxAdapter(
                    child: StreakCard(
                      onSharePressed: () {
                        //TODO implement share code
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  sliver: SliverToBoxAdapter(
                    child: QuestSection(
                      quests: state.quests,
                      questCompletionStatus: state.questCompletionStatus,
                      completionPercentage: state.completionPercentage,
                      onQuestStatusChanged: (index, status) {
                        context
                            .read<QuestBloc>()
                            .add(UpdateQuestStatus(index, status));
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is QuestError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
