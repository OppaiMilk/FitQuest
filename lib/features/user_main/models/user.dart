class User {
  final String id;
  final String name;
  final int currentStreak;
  final DateTime lastCompletedDate;
  final int totalPoints;
  final int completedSessions;
  final String email;
  final String location;

  const User({
    required this.id,
    required this.name,
    required this.currentStreak,
    required this.lastCompletedDate,
    required this.totalPoints,
    required this.completedSessions,
    required this.email,
    required this.location,
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
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, currentStreak: $currentStreak, lastCompletedDate: $lastCompletedDate, totalPoints: $totalPoints, completedSessions: $completedSessions, email: $email, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.currentStreak == currentStreak &&
        other.lastCompletedDate == lastCompletedDate &&
        other.totalPoints == totalPoints &&
        other.completedSessions == completedSessions &&
        other.email == email &&
        other.location == location;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    currentStreak.hashCode ^
    lastCompletedDate.hashCode ^
    totalPoints.hashCode ^
    completedSessions.hashCode ^
    email.hashCode ^
    location.hashCode;
  }
}