import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  final _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      // 使用 Firebase 的 createUserWithEmailAndPassword 方法创建新用户
      final UserCredential create = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 如果成功，返回创建的用户
      return create.user;
    } on FirebaseAuthException catch (e) {
      // 捕获和处理 FirebaseAuthException 错误
      print('FirebaseAuthException: ${e.message}');
      return null;
    } catch (e) {
      // 捕获和处理其他类型的错误
      print('Unexpected error: $e');
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      // 使用 Firebase 的 signInWithEmailAndPassword 方法登录用户
      final UserCredential signInResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 如果成功，返回登录的用户
      return signInResult.user;
    } on FirebaseAuthException catch (e) {
      // 捕获和处理 FirebaseAuthException 错误
      print('FirebaseAuthException: ${e.message}');
      return null;
    } catch (e) {
      // 捕获和处理其他类型的错误
      print('Unexpected error: $e');
      return null;
    }
  }
}
