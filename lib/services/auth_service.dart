import 'package:firebase_auth/firebase_auth.dart';
import 'package:community_energy_optimizer/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserModel?> registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await user?.updateDisplayName(name);
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  UserModel? _userFromFirebase(User? user) {
    return user != null
        ? UserModel(
            uid: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            avatarUrl: user.photoURL ?? '',
          )
        : null;
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }
}
