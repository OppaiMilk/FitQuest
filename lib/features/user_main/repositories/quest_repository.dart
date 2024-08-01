import 'package:calories_tracking/features/user_main/models/quest.dart';

class QuestRepository {
  // Simulating a data source
  final List<Quest> _quests = [
    Quest(id: '1', title: 'Morning Run', description: 'Run for 30 minutes', points: 50, completed: false),
    Quest(id: '2', title: 'Healthy Breakfast', description: 'Eat a balanced breakfast', points: 30, completed: true),
    Quest(id: '3', title: 'Meditation', description: 'Meditate for 10 minutes', points: 20, completed: true),
  ];

  Future<List<Quest>> getQuests() async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    return _quests;
  }

  Future<void> updateQuestStatus(String questId, bool completed) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));

    final questIndex = _quests.indexWhere((quest) => quest.id == questId);
    if (questIndex != -1) {
      _quests[questIndex] = _quests[questIndex].copyWith(completed: completed);
    }
  }
}