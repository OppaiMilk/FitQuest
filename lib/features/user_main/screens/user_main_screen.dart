import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/user_main/models/user.dart';
import 'package:calories_tracking/features/user_main/models/quest.dart';
import 'package:calories_tracking/features/user_main/bloc/quest_bloc.dart';
import 'package:calories_tracking/features/user_main/bloc/user_bloc.dart';
import 'package:calories_tracking/features/user_main/widgets/bottom_navigation.dart';
import 'package:calories_tracking/features/user_main/widgets/quest_section.dart';
import 'package:calories_tracking/features/user_main/widgets/streak_card.dart';
import 'package:calories_tracking/features/user_main/widgets/quest_item.dart';

class UserMainScreen extends StatelessWidget {
  const UserMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(FetchUser('1'));

    return Scaffold(
      backgroundColor: AppTheme.tertiaryColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: const BottomNavigationBarWidget(),
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

  Widget _buildBody() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          return BlocBuilder<QuestBloc, QuestState>(
            builder: (context, questState) {
              if (questState is QuestInitial) {
                context.read<QuestBloc>().add(FetchQuests());
              }
              return _buildContent(userState.user, questState, userState.allQuestsCompletedToday);
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildContent(User user, QuestState questState, bool allQuestsCompletedToday) {
    if (questState is QuestLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (questState is QuestLoaded) {
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
              child: _buildQuestSection(questState),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildQuestSection(QuestLoaded questState) {
    return QuestSection(
      quests: questState.quests.map((quest) => QuestData(
        title: quest.title,
        description: quest.description,
        isCompleted: quest.completed,
      )).toList(),
      completionPercentage: questState.completionPercentage,
      questItemBuilder: (context, index) => _buildQuestItem(context, questState.quests[index]),
      onSharePressed: () {
        // TODO: Implement share functionality
      },
    );
  }

  Widget _buildQuestItem(BuildContext context, Quest quest) {
    return QuestItem(
      name: quest.title,
      description: quest.description,
      isCompleted: quest.completed,
      onStatusChanged: (status) {
        context.read<QuestBloc>().add(UpdateQuestStatus(quest.id, status));
      },
    );
  }
}