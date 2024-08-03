import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/constant/firestore_constants.dart';

class SystemAdmin {
  final String? id;
  final String? uid;
  final String? email;
  final String? name;
  final String? role;
  final String? dateOfBirth;
  final String? phoneNumber;
  final String? createdAt;
  final String? updatedAt;

  SystemAdmin(
      {this.id,
        this.uid,
        this.email,
        this.name,
        this.role,
        this.dateOfBirth,
        this.phoneNumber,
        this.createdAt,
        this.updatedAt});

  final docRef = FirebaseFirestore.instance.collection("Admin").withConverter(
    fromFirestore: SystemAdmin.fromFirestore,
    toFirestore: (SystemAdmin admin, options) => admin.toFirestore(),
  );

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) Admin.uid: uid,
      if (email != null) Admin.email: email,
      if (name != null) Admin.name: name,
      if (dateOfBirth != null) Admin.dateOfBirth: dateOfBirth,
      if (createdAt != null) Admin.createdAt: createdAt,
      if (updatedAt != null) Admin.updatedAt: updatedAt,
    };
  }

  factory SystemAdmin.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return SystemAdmin(
        id: snapshot.id,
        uid: data?[Admin.uid],
        email: data?[Admin.email],
        name: data?[Admin.name],
        dateOfBirth: data?[Admin.dateOfBirth],
        createdAt: data?[Admin.createdAt],
        updatedAt: data?[Admin.updatedAt]);
  }

  Future<String> createAdmin() async {
    print("create Admin");
    final newAdmin = await docRef.add(this);
    return newAdmin.id;
  }

  updateAdmin(String id) {
    String errorMessage = "";
    docRef
        .doc(id)
        .update(toFirestore())
        .then((value) => {errorMessage = "Successfully updated"})
        .onError(
            (error, stackTrace) => {errorMessage = "Failed to update: $error"});
    return errorMessage;
  }

  Future<SystemAdmin?> getAdmin(String id) async {
    final getAdmin = await docRef.doc(id).get();
    return getAdmin.data();
  }

  Future<SystemAdmin?> getAdminByUid(String uid) async {
    QuerySnapshot<SystemAdmin> Admin =
    await docRef.where("uid", isEqualTo: uid).get();
    return Admin.docs.first.data();
  }

}
