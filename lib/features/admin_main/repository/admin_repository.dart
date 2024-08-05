import 'package:calories_tracking/features/admin_main/model/admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRepository {
  final CollectionReference _adminsCollection =
      FirebaseFirestore.instance.collection('admins');

  Future<Admin> getAdminById(String id) async {
    try {
      DocumentSnapshot doc = await _adminsCollection.doc(id).get();
      if (doc.exists) {
        return Admin(
          id: doc.id,
          name: doc['name'],
          email: doc['email'],
        );
      } else {
        return Admin(
          id: id,
          name: 'Unknown User',
          email: 'unknown@example.com',
        );
      }
    } catch (e) {
      print('Error getting user: $e');
      return Admin(
        id: id,
        name: 'Unknown User',
        email: 'unknown@example.com',
      );
    }
  }

  Future<void> updateAdmin(Admin admin) async {
    try {
      await _adminsCollection.doc(admin.id).set({
        'name': admin.name,
        'email': admin.email,
      });
    } catch (e) {
      print('Error updating user: $e');
    }
  }
}
