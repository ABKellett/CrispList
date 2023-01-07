import 'package:capstone_app/models/listItem.dart';
import 'package:capstone_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:capstone_app/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create user object per the FirebaseUser.
  TheUser? _userFromFirebaseUser(User? user) {
    return user != null ? TheUser(uid: user.uid) : null;
  }

  //Auth change user stream
  Stream<TheUser?> get user {
    return _auth
        //TODO: Fix nullable TheUser
        .authStateChanges()
        .map(_userFromFirebaseUser);
  }

  //Email sign in
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Register with email and password
  Future registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      String? theuid = user?.uid;
      List<ListItem> dummy = [
        (ListItem(name: 'Apple', quantity: '1', store: 'Smith\'s'))
      ];

      //Create doc space for new user.
      await DatabaseService(uid: user!.uid).updateUserData(dummy);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
