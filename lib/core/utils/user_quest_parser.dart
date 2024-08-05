import 'package:calories_tracking/features/user_main/models/user.dart';
import 'package:calories_tracking/features/user_main/models/quest.dart';

class UserQuestParser {
  static Map<String, dynamic> parseUserWithQuests(
    User user,
    List<Quest> allQuests,
  ) {
    final userQuests = allQuests.map((quest) {
      final isCompleted = user.completedQuestIds.contains(quest.id);
      return {
        'quest': quest,
        'completed': isCompleted,
      };
    }).toList();

    return {
      'user': user,
      'quests': userQuests,
    };
  }

  static List<Map<String, dynamic>> parseUsersWithQuests(
    List<User> users,
    List<Quest> allQuests,
  ) {
    return users.map((user) => parseUserWithQuests(user, allQuests)).toList();
  }
}
