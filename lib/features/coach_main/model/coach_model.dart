class Coach {
  final String id;
  final String uid;
  final String name;
  final int numOfRatings;
  final double rating;
  final String email;
  final String location;
  final int yearsOfExperience;
  final int completedSessions;
  final List<String> workoutIds;
  final String profileUrl;

  const Coach(
      {required this.id,
        required this.uid,
        required this.name,
        required this.numOfRatings,
        required this.rating,
        required this.email,
        required this.location,
        required this.yearsOfExperience,
        required this.completedSessions,
        required this.workoutIds,
        required this.profileUrl,});

  Coach copyWith({
    String? id,
    String? uid,
    String? name,
    String? email,
    int? numOfRatings,
    double? rating,
    int? yearsOfExperience,
    int? completedSessions,
    String? location,
    List<String>? workoutIds,
    String? profileUrl,
  }) {
    return Coach(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      numOfRatings: numOfRatings ?? this.numOfRatings,
      rating: rating ?? this.rating,
      completedSessions: completedSessions ?? this.completedSessions,
      email: email ?? this.email,
      location: location ?? this.location,
      profileUrl: profileUrl ?? this.profileUrl,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      workoutIds: workoutIds ?? this.workoutIds,
    );
  }
}
