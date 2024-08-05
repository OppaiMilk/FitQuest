import 'package:calories_tracking/features/user_main/models/quest.dart';

class QuestRepository {
  // Simulating a data source
  final List<Quest> _quests = [
    Quest(
        id: 'Q1',
        title: 'Morning Stretch',
        description: 'Quick 5-minute full body stretch',
        points: 1),
    Quest(
        id: 'Q2',
        title: 'Hydration Boost',
        description: 'Drink 3 glasses of water',
        points: 1),
    Quest(
        id: 'Q3',
        title: 'Lunch Walk',
        description: 'Take a 15-minute walk after lunch',
        points: 2),
    Quest(
        id: 'Q4',
        title: 'Strength Circuit',
        description: 'Complete 20-minute bodyweight workout',
        points: 3),
    Quest(
        id: 'Q5',
        title: 'Evening Yoga',
        description: 'Do 30-minute yoga session',
        points: 3),
  ];

  Future<List<Quest>> getQuests() async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    return _quests;
  }

  Future<void> updateQuestStatus(String questId, bool completed) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
  }
}
