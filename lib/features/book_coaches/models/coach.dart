class Coach {
  final String id;
  final String name;
  final int numOfRatings;
  final double rating;
  final String email;
  final String location;
  final int yearsOfExperience;
  final int completedSessions;
  final List<String> workoutIds;
  final String profileUrl;

  Coach({
    required this.id,
    required this.name,
    required this.numOfRatings,
    required this.rating,
    required this.email,
    required this.location,
    required this.yearsOfExperience,
    required this.completedSessions,
    required this.workoutIds,
    required this.profileUrl,
  });

  @override
  String toString() {
    return 'Coach{id: $id, name: $name, numOfRatings: $numOfRatings, rating: $rating, email: $email, location: $location, yearsOfExperience: $yearsOfExperience, completedSessions: $completedSessions, workoutIds: $workoutIds, profileUrl: $profileUrl}';
  }
}
