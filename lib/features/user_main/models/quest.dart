// quest.dart
class Quest {
  final String id;
  final String title;
  final String description;
  final int points;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
  });

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
    );
  }
}
