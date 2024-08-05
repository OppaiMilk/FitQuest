import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  final _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential create = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return create.user;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential signInResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return signInResult.user;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }
}
