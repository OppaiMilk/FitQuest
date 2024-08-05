class FirestoreConstants {
  // Common fields
  static const id = "id";
  static const role = "role";
  static const createdAt = "createdAt";
  static const updatedAt = "updatedAt";
}


// Users Collection
class Admin extends FirestoreConstants {
  static const userId = FirestoreConstants.id;
  static const uid = "uid";
  static const role = "role";
  static const email = 'email';
  static const name = 'name';
  static const dateOfBirth = 'dateOfBirth';
  static const createdAt = FirestoreConstants.createdAt;
  static const updatedAt = FirestoreConstants.updatedAt;
}

class User extends FirestoreConstants {
  static const userId = FirestoreConstants.id;
  static const uid = "uid";
  static const role = "role";
  static const email = 'email';
  static const status = "status";
  static const qualifications = 'qualification';
  static const name = 'name';
  static const location = 'location';
  static const createdAt = FirestoreConstants.createdAt;
  static const updatedAt = FirestoreConstants.updatedAt;
}