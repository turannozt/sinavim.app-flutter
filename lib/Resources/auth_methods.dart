import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:sinavim_app/models/user.dart' as model;

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required String token,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        model.User user = model.User(
          constMessage: "",
          adsPoint: 0,
          engelkontrol: "false",
          token: token,
          username: username,
          uid: cred.user!.uid,
          profImage: 'https://i.stack.imgur.com/l60Hf.png',
          email: email,
          password: password,
          bio: bio,
          followers: [],
          following: [],
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
    required String token,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

// change e mail
  void changeEmail(String newEmail) async {
    if (newEmail.isNotEmpty) {
      await _auth.currentUser!.updateEmail(newEmail);
    } else {
      debugPrint('Güncellemek İstemiyor Demekki Aga Zorlama');
    }
  }

  //change password
  void changePassword(String newPassword) async {
    if (newPassword.isNotEmpty) {
      await _auth.currentUser!.updatePassword(newPassword);
    } else {
      debugPrint('Güncellemek İstemiyor Demekki Aga Zorlama');
    }
  }
// reset password
  Future<String> resetPassword(String email) async {
    String res = "error";
    try {
      await _auth.sendPasswordResetEmail(email: email);
      res = "success";
    } catch (e) {
      debugPrint(e.toString());
    }
    return res;
  }
}
