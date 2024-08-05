class Quest {
  final String id;
  final String title;
  final String description;
  final int points;
  final DateTime lastGenerated;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.lastGenerated,
  });

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
    DateTime? lastGenerated,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      lastGenerated: lastGenerated ?? this.lastGenerated,
    );
  }
}