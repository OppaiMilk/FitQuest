class Quest {
  final String id;
  final String title;
  final String description;
  final int points;
  final bool completed;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    this.completed = false,
  });

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
    bool? completed,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      completed: completed ?? this.completed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Quest &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              title == other.title &&
              description == other.description &&
              points == other.points &&
              completed == other.completed;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      points.hashCode ^
      completed.hashCode;

  @override
  String toString() {
    return 'Quest{id: $id, title: $title, description: $description, points: $points, completed: $completed}';
  }
}