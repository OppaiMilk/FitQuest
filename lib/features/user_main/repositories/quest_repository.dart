import 'package:calories_tracking/features/user_main/models/quest.dart';

class QuestRepository {
  Future<List<Quest>> getQuests() async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      Quest(
        id: '1',
        title: 'Morning Jog',
        description: 'Go for a 20-minute jog in the morning',
        points: 50,
      ),
      Quest(
        id: '2',
        title: 'Healthy Breakfast',
        description: 'Eat a balanced breakfast with protein and fruits',
        points: 30,
      ),
      Quest(
        id: '3',
        title: 'Hydration',
        description: 'Drink 8 glasses of water throughout the day',
        points: 40,
      ),
      Quest(
        id: '4',
        title: 'Meditation',
        description: 'Practice mindfulness meditation for 10 minutes',
        points: 35,
      ),
      Quest(
        id: '5',
        title: 'Strength Training',
        description: 'Complete a 30-minute strength training session',
        points: 60,
      ),
    ];
  }

  Future<Quest> getQuestDetails(String id) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));

    final quests = await getQuests();
    return quests.firstWhere(
      (quest) => quest.id == id,
      orElse: () => Quest(
        id: id,
        title: 'Unknown Quest',
        description: 'This quest does not exist',
        points: 0,
      ),
    );
  }
}
