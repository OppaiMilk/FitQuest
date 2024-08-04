class Workout {
  final String id;
  final String name;
  final String url;

  Workout({
    required this.id,
    required this.name,
    required this.url,
  });

  @override
  String toString() {
    return 'Workout{id: $id, name: $name, url: $url}';
  }
}
