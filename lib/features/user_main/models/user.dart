// user.dart
class User {
  final String id;
  final String name;
  final int currentStreak;
  final DateTime lastCompletedDate;
  final int totalPoints;
  final int completedSessions;
  final String email;
  final String location;
  final List<String> completedQuestIds; // New field
  final String profileUrl;

  const User({
    required this.id,
    required this.name,
    required this.currentStreak,
    required this.lastCompletedDate,
    required this.totalPoints,
    required this.completedSessions,
    required this.email,
    required this.location,
    required this.completedQuestIds,
    required this.profileUrl,
  });

  User copyWith({
    String? id,
    String? name,
    int? currentStreak,
    DateTime? lastCompletedDate,
    int? totalPoints,
    int? completedSessions,
    String? email,
    String? location,
    List<String>? completedQuestIds, // New field
    String? profileUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      currentStreak: currentStreak ?? this.currentStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      totalPoints: totalPoints ?? this.totalPoints,
      completedSessions: completedSessions ?? this.completedSessions,
      email: email ?? this.email,
      location: location ?? this.location,
      completedQuestIds: completedQuestIds ?? this.completedQuestIds, // New field
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }
}