class Activity {
  final String id;
  final String title;

  Activity({
    required this.id,
    required this.title,
  });

  @override
  String toString() {
    return 'Activity{id: $id, title: $title}';
  }
}
