import 'package:calories_tracking/features/commonWidget/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/user_main/models/user.dart';
import 'package:calories_tracking/features/user_main/models/quest.dart';
import 'package:calories_tracking/features/user_main/bloc/quest_bloc.dart';
import 'package:calories_tracking/features/user_main/bloc/user_bloc.dart';
import 'package:calories_tracking/features/user_main/widgets/quest_section.dart';
import 'package:calories_tracking/features/user_main/widgets/streak_card.dart';
import 'package:calories_tracking/features/user_main/widgets/quest_item.dart';
import 'package:calories_tracking/features/community/screens/community_screen.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);

  @override
  _UserMainScreenState createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUser('1'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tertiaryColor,
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildMainContent(),
          const Center(child: Text('Calendar Screen')),
          const Center(child: Text('Chat Screen')),
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
          return const Text('Welcome');
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: AppTheme.primaryTextColor),
          onPressed: () {
            // TODO: Implement notification functionality
          },
        ),
      ],
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
          padding: const EdgeInsets.all(18),
          sliver: SliverToBoxAdapter(
            child: StreakCard(
              currentStreak: user.currentStreak,
              onSharePressed: () {
                // TODO: Implement share functionality
              },
              allQuestsCompletedToday: allQuestsCompletedToday,
              lastCompletedDate: user.lastCompletedDate,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          sliver: SliverToBoxAdapter(
            child: _buildQuestSection(questState, user.completedQuestIds),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestSection(QuestLoaded questState, List<String> completedQuestIds) {
    return QuestSection(
      quests: questState.quests.map((quest) => QuestData(
        title: quest.title,
        description: quest.description,
        isCompleted: completedQuestIds.contains(quest.id),
      )).toList(),
      completionPercentage: questState.completionPercentage,
      questItemBuilder: (context, index) => _buildQuestItem(context, questState.quests[index], completedQuestIds),
      onSharePressed: () {
        // TODO: Implement share functionality
      },
    );
  }

  Widget _buildQuestItem(BuildContext context, Quest quest, List<String> completedQuestIds) {
    return QuestItem(
      name: quest.title,
      description: quest.description,
      isCompleted: completedQuestIds.contains(quest.id),
      onStatusChanged: (status) {
        context.read<QuestBloc>().add(UpdateQuestStatus(quest.id, status));
      },
    );
  }
}