// admin.dart
class Admin {
  final String id;
  final String name;
  final String email;


  const Admin({
    required this.id,
    required this.name,
    required this.email,

  });

  Admin copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return Admin(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,

    );
  }
}