import 'package:calories_tracking/features/commonWidget/appbar.dart';
import 'package:calories_tracking/features/community/screens/user_community_screen.dart';
import 'package:calories_tracking/features/user_calendar/screens/user_calendar.dart';
import 'package:calories_tracking/features/user_leaderboard/leaderboard_screen.dart';
import 'package:calories_tracking/features/user_main/models/quest.dart';
import 'package:calories_tracking/features/user_main/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/user_main/bloc/quest_bloc.dart';
import 'package:calories_tracking/features/user_main/bloc/user_bloc.dart';
import 'package:calories_tracking/features/commonWidget/bottom_navigation.dart';
import 'package:calories_tracking/features/user_main/widgets/quest_section.dart';
import 'package:calories_tracking/features/user_main/widgets/streak_card.dart';
import 'package:calories_tracking/features/user_main/widgets/quest_item.dart';
import 'package:calories_tracking/features/community/repositories/activity_repository.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  _UserMainScreenState createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _currentIndex = 0;
  final ActivityRepository _activityRepository = ActivityRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tertiaryColor,
      appBar: CustomAppBar(
        role: appbarType.user,
        currentIndex: _currentIndex,

      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildMainContent(),
          const UserBookingsScreen(),
          LeaderboardScreen(),
          const CommunityScreen(),
          const Center(child: Text('Settings Screen')),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        role: UserRole.user,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      title: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            return _buildWelcomeText(state.user.name);
          }
          return const Text('Loading...');
        },
      ),
    );
  }

  Widget _buildWelcomeText(String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome Back',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          userName,
          style: const TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          return BlocBuilder<QuestBloc, QuestState>(
            builder: (context, questState) {
              if (questState is QuestInitial) {
                context.read<QuestBloc>().add(FetchQuests());
              }
              if (questState is QuestLoaded) {
                return _buildContent(userState.user, questState, userState.allQuestsCompletedToday);
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildContent(User user, QuestLoaded questState, bool allQuestsCompletedToday) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: StreakCard(
              currentStreak: user.currentStreak,
              onSharePressed: () => _shareStreak(user),
              allQuestsCompletedToday: allQuestsCompletedToday,
              lastCompletedDate: user.lastCompletedDate,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          sliver: SliverToBoxAdapter(
            child: _buildQuestSection(questState, user),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestSection(QuestLoaded questState, User user) {
    return QuestSection(
      quests: questState.quests.map((quest) => QuestData(
        title: quest.title,
        description: quest.description,
        isCompleted: user.completedQuestIds.contains(quest.id),
      )).toList(),
      completionPercentage: questState.completionPercentage,
      questItemBuilder: (context, index) => _buildQuestItem(context, questState.quests[index], user.completedQuestIds),
      onSharePressed: () => _shareCompletedQuests(user, questState),
    );
  }

  Widget _buildQuestItem(BuildContext context, Quest quest, List<String> completedQuestIds) {
    return QuestItem(
      name: quest.title,
      description: quest.description,
      isCompleted: completedQuestIds.contains(quest.id),
      points: quest.points,
      onStatusChanged: (status) {
        context.read<QuestBloc>().add(UpdateQuestStatus(quest.id, status));
      },
    );
  }

  Future<void> _shareStreak(User user) async {
    try {
      String title = '${user.name} has reached their ${user.currentStreak} day streak!';
      await _activityRepository.addActivity(title);

      // Check if the widget is still mounted before using context
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Streak shared successfully!')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share streak. Please try again.')),
      );
    }
  }

  Future<void> _shareCompletedQuests(User user, QuestLoaded questState) async {
    try {
      int completedQuests = user.completedQuestIds.length;
      int totalPoints = _calculateTotalPoints(user.completedQuestIds, questState.quests);

      String title = '${user.name} has completed $completedQuests quests and got $totalPoints points!';
      await _activityRepository.addActivity(title);

      // Check if the widget is still mounted before using context
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quest completion shared successfully!')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share quest completion. Please try again.')),
      );
    }
  }

  int _calculateTotalPoints(List<String> completedQuestIds, List<Quest> allQuests) {
    return allQuests
        .where((quest) => completedQuestIds.contains(quest.id))
        .fold(0, (sum, quest) => sum + (quest.points));
  }
}
