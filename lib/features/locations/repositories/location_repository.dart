import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calories_tracking/features/locations/models/location.dart';

class LocationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Location>> getLocations() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('locations').get();
      return querySnapshot.docs.map((doc) {
        return Location(
          id: doc.id,
          name: doc['name'] ?? 'Unknown Location',
        );
      }).toList();
    } catch (e) {
      print('Error fetching locations: $e');
      return [];
    }
  }

  Future<Location?> getLocationById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('locations').doc(id).get();
      if (doc.exists) {
        return Location(
          id: doc.id,
          name: doc['name'] ?? 'Unknown Location',
        );
      } else {
        print('Location not found');
        return null;
      }
    } catch (e) {
      print('Error fetching location details: $e');
      return null;
    }
  }

  Future<bool> addLocation(String name) async {
    try {
      await _firestore.collection('locations').add({
        'name': name,
      });
      return true;
    } catch (e) {
      print('Error adding location: $e');
      return false;
    }
  }

  Future<bool> updateLocation(String id, String name) async {
    try {
      await _firestore.collection('locations').doc(id).update({
        'name': name,
      });
      return true;
    } catch (e) {
      print('Error updating location: $e');
      return false;
    }
  }

  Future<bool> deleteLocation(String id) async {
    try {
      await _firestore.collection('locations').doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting location: $e');
      return false;
    }
  }
}