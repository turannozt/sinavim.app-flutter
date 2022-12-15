import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String profImage;
  final String username;
  final String bio;
  final String password;
  final List followers;
  final List following;
  final String token;
  final String engelkontrol;
  final int adsPoint;
  final String constMessage;

  const User({
    required this.constMessage,
    required this.adsPoint,
    required this.engelkontrol,
    required this.token,
    required this.username,
    required this.password,
    required this.uid,
    required this.profImage,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
  });
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      constMessage: snapshot['constMessage'],
      adsPoint: snapshot['adsPoint'],
      engelkontrol: snapshot["engelKontrol"],
      token: snapshot["token"],
      username: snapshot["username"],
      uid: snapshot["uid"],
      password: snapshot["password"],
      email: snapshot["email"],
      profImage: snapshot["profImage"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
        "constMessage": constMessage,
        "adsPoint": adsPoint,
        "engelKontrol": engelkontrol,
        "token": token,
        "username": username,
        "password": password,
        "uid": uid,
        "email": email,
        "profImage": profImage,
        "bio": bio,
        "followers": followers,
        "following": following,
      };
}
