class Coach {
  final String id;
  final String name;
  final double rating;
  final String email;
  final String location;
  final int yearsOfExperience;
  final int completedSessions;
  final List<String> workouts;
  final String profileUrl;

  Coach({
    required this.id,
    required this.name,
    required this.rating,
    required this.email,
    required this.location,
    required this.yearsOfExperience,
    required this.completedSessions,
    required this.workouts,
    required this.profileUrl,
  });
}