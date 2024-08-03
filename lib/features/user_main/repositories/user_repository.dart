import 'package:calories_tracking/features/user_main/models/user.dart';
import 'package:calories_tracking/core/utils/time_parser.dart';

class UserRepository {
  // Simulating a data source
  final List<User> _users = [
    User(
      id: '1',
      name: 'John Snow',
      currentStreak:12,
      lastCompletedDate: TimeParser.getMalaysiaTime().subtract(const Duration(days: 1)),
      totalPoints: 150,
      completedSessions: 12,
      email: 'john.snow@example.com',
      location: 'Kuala Lumpur',
      completedQuestIds: [],
    ),
  ];

  Future<User> getUserById(String id) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));

    return _users.firstWhere(
          (user) => user.id == id,
      orElse: () => User(
        id: id,
        name: 'Unknown User',
        currentStreak: 0,
        lastCompletedDate: TimeParser.getMalaysiaTime(),
        totalPoints: 0,
        completedSessions: 0,
        email: 'unknown@example.com',
        location: 'Unknown',
        completedQuestIds: [],
      ),
    );
  }

  Future<void> updateUser(User user) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));

    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    } else {
      _users.add(user);
    }
  }
}