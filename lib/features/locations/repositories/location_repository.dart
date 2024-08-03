import 'package:calories_tracking/features/locations/models/location.dart';

class LocationRepository {
  Future<List<Location>> getLocations() async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      Location(id: 'L1', name: 'Gym'),
      Location(id: 'L2', name: 'Park'),
      Location(id: 'L3', name: 'Home'),
      Location(id: 'L4', name: 'Beach'),
      Location(id: 'L5', name: 'Studio'),
    ];
  }
}