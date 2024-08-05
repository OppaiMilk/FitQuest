import 'dart:async';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/core/utils/user_quest_parser.dart';
import 'package:calories_tracking/features/book_coaches/widgets/square_info_card.dart';
import 'package:calories_tracking/features/coach_main/widgets/quest_card.dart';
import 'package:calories_tracking/features/user_main/models/quest.dart';
import 'package:calories_tracking/features/user_main/models/user.dart';
import 'package:calories_tracking/features/user_main/repositories/quest_repository.dart';
import 'package:calories_tracking/features/user_main/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;

  const UserDetailsScreen({
    super.key,
    required this.userId,
  });

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final UserRepository _userRepository = UserRepository();
  final QuestRepository _questRepository = QuestRepository();
  late StreamController<Map<String, dynamic>> _streamController;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<Map<String, dynamic>>();
    _loadData();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final user = await _userRepository.getUserById(widget.userId);
      final allQuests = await _questRepository.getQuests();
      final parsedData = UserQuestParser.parseUserWithQuests(user, allQuests);

      // Convert the list of maps back to a list of Quest objects
      final quests = (parsedData['quests'] as List<dynamic>)
          .map((questMap) => Quest(
                id: questMap['id'] as String,
                title: questMap['title'] as String,
                description: questMap['description'] as String,
                points: questMap['points'] as int,
              ))
          .toList();

      // Update the parsedData with the new list of Quest objects
      parsedData['quests'] = quests;

      _streamController.add(parsedData);
    } catch (e) {
      _streamController.addError(e);
    }
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
          'User Details',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: StreamBuilder<Map<String, dynamic>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final user = snapshot.data!['user'] as User;
              final quests = snapshot.data!['quests'] as List<Quest>;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(user),
                    const SizedBox(height: 16),
                    _buildUserInfo(user),
                    const SizedBox(height: 16),
                    _buildInfoCards(context, user),
                    const SizedBox(height: 24),
                    _buildRecentQuests(quests),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Center(
      child: CircleAvatar(
        backgroundColor: AppTheme.secondaryColor,
        radius: 70,
        child: ClipOval(
          child: Image.network(
            user.profileUrl,
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

  Widget _buildUserInfo(User user) {
    return Center(
      child: Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(
              color: AppTheme.tertiaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user.email,
            style: const TextStyle(
              color: AppTheme.secondaryTextColor,
              fontSize: 16,
            ),
          ),
          Text(
            user.location,
            style: const TextStyle(
              color: AppTheme.secondaryTextColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context, User user) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        color: AppTheme.secondaryColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    _buildSquareInfoCard(
                        '${user.currentStreak}', 'Days of\nStreak'),
                    const SizedBox(width: 8),
                    _buildSquareInfoCard(
                        '${user.totalPoints}', 'Total\nPoints'),
                    const SizedBox(width: 8),
                    _buildSquareInfoCard(
                        '${user.completedSessions}', 'Completed\nSessions'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareInfoCard(String value, String label) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: SquareInfoCard(
          value: value,
          label: label,
          backgroundColor: AppTheme.tertiaryColor,
          textColor: AppTheme.tertiaryTextColor,
        ),
      ),
    );
  }

  Widget _buildRecentQuests(List<Quest> quests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Quests',
          style: TextStyle(
            color: AppTheme.tertiaryTextColor,
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
          itemCount: quests.length,
          itemBuilder: (context, index) => QuestCard(
            questTitle: quests[index].title,
            backgroundColor: AppTheme.secondaryColor,
            textColor: AppTheme.primaryTextColor,
            gradientColor: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }
}
