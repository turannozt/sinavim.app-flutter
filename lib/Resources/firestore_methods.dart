import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sinavim_app/Resources/auth_methods.dart';
import 'package:sinavim_app/Resources/storage_methods.dart';
import 'package:sinavim_app/models/post.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  fotoğraflı gönderi
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
    String tag,
    String token,
  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String postUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        token: token,
        tag: tag,
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //  yazılı gönderi
  Future<String> uploadPostText(String description, String uid, String username,
      String profImage, String tag, String token) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        token: token,
        tag: tag,
        postUrl: '',
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //  fotoğraflı gönderi beğenme
  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      String userName = (snap.data()! as dynamic)['username'];
      String profImage = (snap.data()! as dynamic)['profImage'];
      var check = likes.toList().any((element) => element['uid'].contains(uid));
      var index =
          likes.toList().indexWhere((element) => element['uid'].contains(uid));
      if (check) {
        // if the likes list contains the user uid, we need to remove it
        // ignore: avoid_print
        print(likes.toList()[index]);
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([likes.toList()[index]])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([
            {"uid": uid, "username": userName, "profImage": profImage}
          ])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
      // ignore: avoid_print
      print(res);
    }
    return res;
  }

// yorum beğenme
  Future<String> likeCommentPost(
    String postId,
    String commentId,
    String uid,
    List likes,
  ) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //  yazılı gönderi beğenisi
  Future<String> likeTextPost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      String userName = (snap.data()! as dynamic)['username'];
      String profImage = (snap.data()! as dynamic)['profImage'];
      var check = likes.toList().any((element) => element['uid'].contains(uid));
      var index =
          likes.toList().indexWhere((element) => element['uid'].contains(uid));
      if (check) {
        // if the likes list contains the user uid, we need to remove it
        // ignore: avoid_print
        print(likes.toList()[index]);
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([likes.toList()[index]])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([
            {"uid": uid, "username": userName, "profImage": profImage}
          ])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
      // ignore: avoid_print
      print(res);
    }
    return res;
  }

  // fotoğraflı gönderi yorumu
  Future<String> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profImage,
    List likes,
    String token,
  ) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profImage': profImage,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': likes,
          'token': token
        });
        res = 'success';
      } else {
        res = "Metin Giriniz...";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //  yazılı göndeeri yorumu
  Future<String> postCommentText(
    String postId,
    String text,
    String uid,
    String name,
    String profImage,
    List likes,
    String token,
  ) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profImage': profImage,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'likes': likes,
          'datePublished': DateTime.now(),
          'token': token
        });
        res = 'success';
      } else {
        res = "Metin Giriniz...";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post fotoğraflı
  Future<String> deletePost(String postId, String commentId) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post Yazılı gönderi
  Future<String> deleteTextPost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//followers following
  Future<void> followUser(String uid, String followId) async {
    try {
      //UserFollowing
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();

      //FollowList

      ///User
      DocumentSnapshot userSnap =
          await _firestore.collection('users').doc(uid).get();
      String userName = (userSnap.data()! as dynamic)['username'];
      String profImage = (userSnap.data()! as dynamic)['profImage'];
      List followingList = (snap.data()! as dynamic)['following'];

      ///FollowUser
      DocumentSnapshot followSnap =
          await _firestore.collection('users').doc(followId).get();
      String followUserName = (followSnap.data()! as dynamic)['username'];
      String followPhotoUrl = (followSnap.data()! as dynamic)['profImage'];
      List followList = (followSnap.data()! as dynamic)['followers'];

      ///checkfollowing Lİst
      var check = followingList
          .toList()
          .any((element) => element['uid'].contains(followId));
      var index = followingList
          .toList()
          .indexWhere((element) => element['uid'].contains(followId));

      ///CheckFollowList
      var index2 = followList
          .toList()
          .indexWhere((element) => element['uid'].contains(uid));

      if (check) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([followList.toList()[index2]])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followingList.toList()[index]])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([
            {"uid": uid, "username": userName, "profImage": profImage}
          ])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([
            {
              "uid": followId,
              "username": followUserName,
              "profImage": followPhotoUrl
            }
          ])
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// username update
  void dataUsernameUpdate(String uid, String newUsername) async {
    try {
      if (newUsername.isNotEmpty) {
        await _firestore.doc('users/$uid').update({
          'username': newUsername,
        });

        WriteBatch batch = _firestore.batch();
        CollectionReference postsCollectionRef = _firestore.collection('posts');
        var postsCollection =
            await postsCollectionRef.where('uid', isEqualTo: uid).get();
        for (var element in postsCollection.docs) {
          batch.update(element.reference, {'username': newUsername});
        }

        CollectionReference mentorPostsCollectionRef =
            _firestore.collection('MentorPosts');
        var mentorCollection =
            await mentorPostsCollectionRef.where('uid', isEqualTo: uid).get();
        for (var element in mentorCollection.docs) {
          batch.update(element.reference, {'username': newUsername});

          CollectionReference questionsPostsCollectionRef =
              _firestore.collection('Questions');
          var questionCollection = await questionsPostsCollectionRef
              .where('uid', isEqualTo: uid)
              .get();
          for (var element in questionCollection.docs) {
            batch.update(element.reference, {'username': newUsername});
          }
        }
        batch.commit();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//bio update
  void dataBioUpdate(String uid, String newBio) async {
    try {
      if (newBio.isNotEmpty) {
        await _firestore.doc('users/$uid').update({
          'bio': newBio,
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// password update
  void dataPasswordUpdate(
    String emaill,
    String pass,
    String password,
    String uid,
  ) async {
    try {
      await AuthMethods().loginUser(email: emaill, password: pass, token: "");
      if (password.isNotEmpty) {
        await _firestore.doc('users/$uid').update({
          'password': password,
        });
        AuthMethods().changePassword(password);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// profil photo update
  void dataProfilePicUpdate(Uint8List file, String uid) async {
    try {
      String profImage = await StorageMethods()
          .uploadImageToStorage('profilePics', file, false);
      // ignore: unnecessary_null_comparison
      if (file != null) {
        await _firestore.doc('users/$uid').update({
          'profImage': profImage,
        });
      }
      WriteBatch batch = _firestore.batch();

      CollectionReference postsCollectionRef = _firestore.collection('posts');
      var postsCollection =
          await postsCollectionRef.where('uid', isEqualTo: uid).get();
      for (var element in postsCollection.docs) {
        batch.update(element.reference, {'profImage': profImage});
      }

      CollectionReference mentorPostsCollectionRef =
          _firestore.collection('MentorPosts');
      var mentorCollection =
          await mentorPostsCollectionRef.where('uid', isEqualTo: uid).get();
      for (var element in mentorCollection.docs) {
        batch.update(element.reference, {'profImage': profImage});
      }

      CollectionReference questionsPostsCollectionRef =
          _firestore.collection('Questions');
      var questionCollection =
          await questionsPostsCollectionRef.where('uid', isEqualTo: uid).get();
      for (var element in questionCollection.docs) {
        batch.update(element.reference, {'profImage': profImage});
      }
      batch.commit();
    } catch (e) {
      debugPrint(e.toString());
    }
    
  }

//YORUM SİL
  deleteComment(String postId, String commentId) {
    try {
      _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//ŞiKAYET ET
  void reportPost(
    String postId,
    String description,
    String photoUrl,
    String uid,
    String username,
    String sikayetEdenUid,
  ) {
    try {
      _firestore.collection('Reports(PostId)').doc(postId).set({
        'description': description,
        'photoUrl': photoUrl,
        'uid': uid,
        'username': username,
        'sikayetEdenUid': sikayetEdenUid
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//token al
  tokenAl(var token) {
    _firestore
        .doc('users/fZ4MLGApvFbKcaXxnaChcLEaS4s2')
        .update({'token': token});
  }

// Kaydedilenlere ekle
  Future<String> favoriteCard(
      String userUid,
      String uid,
      String postUrl,
      String description,
      String postId,
      String username,
      List likes,
      String profImage,
      String tag,
      String token) async {
    String res = "error";
    try {
      Post post = Post(
        token: token,
        tag: tag,
        datePublished: DateTime.now(),
        description: description,
        uid: uid,
        username: username,
        likes: likes,
        postId: postId,
        postUrl: postUrl,
        profImage: profImage,
      );
      await _firestore
          .collection('users')
          .doc(userUid)
          .collection('favoriteCard')
          .doc(postId)
          .set(post.toJson());
      res = "success";
    } catch (e) {
      e.toString();
    }
    return res;
  }

// Kaydedilenden çıkar
  Future<String> unfavoriteCard(
    String uid,
    String postId,
  ) async {
    String res = "error";
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('favoriteCard')
          .doc(postId)
          .delete();
      res = "success";
    } catch (e) {
      e.toString();
    }
    return res;
  }

//bildirim kaydet
  Future<String> notificationsCollection(
    String notiUid,
    String notiUsername,
    String notiIcerik,
    String profImage,
    DateTime datePub,
  ) async {
    String res = "error";
    try {
      String notiId = const Uuid().v1();
      await _firestore.collection('Notifications').doc(notiId).set({
        "profIamge": profImage,
        "uid": notiUid,
        "notiUsername": notiUsername,
        "notiIcerik": notiIcerik,
        "DateTime": datePub,
      });
      res = "success";
    } catch (e) {
      debugPrint(e.toString());
    }
    return res;
  }

// token güncelle
  Future<String> tokenUpdate(String userId, String newToken) async {
    String res = "error";
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({"token": newToken});

      WriteBatch batch = _firestore.batch();

      CollectionReference postsCollectionRef = _firestore.collection('posts');
      var postsCollection =
          await postsCollectionRef.where('uid', isEqualTo: userId).get();
      for (var element in postsCollection.docs) {
        batch.update(element.reference, {'token': newToken});
      }

      CollectionReference mentorPostsCollectionRef =
          _firestore.collection('MentorPosts');
      var mentorPostsCollection =
          await mentorPostsCollectionRef.where('uid', isEqualTo: userId).get();
      for (var element in mentorPostsCollection.docs) {
        batch.update(element.reference, {'token': newToken});
      }

      CollectionReference questionPostsCollectionRef =
          _firestore.collection('Questions');
      var quesitonPostsCollection = await questionPostsCollectionRef
          .where('uid', isEqualTo: userId)
          .get();
      for (var element in quesitonPostsCollection.docs) {
        batch.update(element.reference, {'token': newToken});
      }

      batch.commit();
      res = "success";
    } catch (e) {
      debugPrint(e.toString());
    }
    return res;
  }

  void deleteNoti(
    String uid,
  ) async {
    try {
      WriteBatch batch = _firestore.batch();
      CollectionReference postsCollectionRef =
          _firestore.collection('Notifications');
      var postsCollection =
          await postsCollectionRef.where('uid', isEqualTo: uid).get();
      for (QueryDocumentSnapshot<Object?> element in postsCollection.docs) {
        batch.delete(element.reference);
      }
      batch.commit();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  addData() async {
    WriteBatch batch = _firestore.batch();
    CollectionReference postsRef = _firestore.collection('posts');
    var counterDocs = await postsRef.get();
    for (var element in counterDocs.docs) {
      batch.update(element.reference, {'savedControl': false});
    }
    batch.commit();
  }
}
