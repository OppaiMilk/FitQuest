import 'package:cloud_firestore/cloud_firestore.dart';

class Quest {
  final String id;
  final String title;
  final String description;
  final int points;
  final DateTime lastGenerated;
  final bool completed;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    DateTime? lastGenerated,
    this.completed = false,
  }) : this.lastGenerated = lastGenerated ?? DateTime.now();

  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      points: map['points'] ?? 0,
      lastGenerated: map['lastGenerated'] != null
          ? (map['lastGenerated'] as Timestamp).toDate()
          : DateTime.now(),
      completed: map['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'lastGenerated': Timestamp.fromDate(lastGenerated),
      'completed': completed,
    };
  }

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
    DateTime? lastGenerated,
    bool? completed,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      lastGenerated: lastGenerated ?? this.lastGenerated,
      completed: completed ?? this.completed,
    );
  }
}