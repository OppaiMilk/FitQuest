import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/constant/firestore_constants.dart';

enum userRole { admin, user, coach }

class SystemUser {
  final String? id;
  final String? uid;
  final String? email;
  final String? name;
  final userRole? role;
  final String? status;
  final String? qualificationLink;
  final String? location;
  final String? createdAt;
  final String? updatedAt;

  SystemUser(
      {this.id,
      this.qualificationLink,
      this.uid,
      this.email,
      this.name,
      this.role,
      this.status,
      this.location,
      this.createdAt,
      this.updatedAt});

  SystemUser copyWith({
    String? id,
    String? uid,
    String? email,
    String? name,
    String? qualificationLink,
    String? status,
    userRole? role,
    String? location,
    String? createdAt,
    String? updatedAt,
  }) {
    return SystemUser(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      status: status?? this.status,
      role: role ?? this.role,
      qualificationLink: qualificationLink ?? this.qualificationLink,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  final docRef = FirebaseFirestore.instance.collection("Users").withConverter(
        fromFirestore: SystemUser.fromFirestore,
        toFirestore: (SystemUser user, options) => user.toFirestore(),
      );

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) User.uid: uid,
      if (email != null) User.email: email,
      if (name != null) User.name: name,
      if (status != null) User.status: status,
      if (role != null) User.role: role!.toString().split('.').last,
      if (qualificationLink != null) User.qualifications: qualificationLink,
      if (location != null) User.location: location,
      if (createdAt != null) User.createdAt: createdAt,
      if (updatedAt != null) User.updatedAt: updatedAt,
    };
  }

  factory SystemUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return SystemUser(
        id: snapshot.id,
        uid: data?[User.uid],
        email: data?[User.email],
        name: data?[User.name],
        status: data?[User.status],
        qualificationLink: data?[User.qualifications],
        role: data != null && data[User.role] != null
            ? userRole.values.firstWhere(
                (e) => e.toString().split('.').last == data[User.role])
            : null,
        location: data?[User.location],
        createdAt: data?[User.createdAt],
        updatedAt: data?[User.updatedAt]);
  }

  Future<String> createUser() async {
    print("create User");
    final newUser = await docRef.add(this);
    return newUser.id;
  }

  updateUser(String id) {
    String errorMessage = "";
    docRef
        .doc(id)
        .update(toFirestore())
        .then((value) => {errorMessage = "Successfully updated"})
        .onError(
            (error, stackTrace) => {errorMessage = "Failed to update: $error"});
    return errorMessage;
  }

  Future<SystemUser?> getUser(String id) async {
    final getUser = await docRef.doc(id).get();
    return getUser.data();
  }

  Future<SystemUser?> getUserByUid(String uid) async {
    QuerySnapshot<SystemUser> user =
        await docRef.where("uid", isEqualTo: uid).get();
    return user.docs.first.data();
  }

// Future<bool> isPhoneNumberExists(String phoneNumber) async {
//   QuerySnapshot<SystemUser> user =
//   await docRef.where(User.phoneNumber, isEqualTo: phoneNumber).get();
//   return user.size > 0;
// }
}
