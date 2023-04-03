import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sinavim_app/Resources/storage_methods.dart';
import 'package:sinavim_app/models/post.dart';

import 'package:uuid/uuid.dart';

class FireStoreMethodsMentor {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// upload mentor post
  // ignore: sdk_version_async_exported_from_core
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage, String tag, String token) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String postUrl = await StorageMethods()
          .uploadImageToStorage('MentorPosts', file, true);
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
      _firestore.collection('MentorPosts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// mentor like post
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
        _firestore.collection('MentorPosts').doc(postId).update({
          'likes': FieldValue.arrayRemove([likes.toList()[index]])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('MentorPosts').doc(postId).update({
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

  // Post comment
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
            .collection('MentorPosts')
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

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('MentorPosts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  deleteCommentMentor(String postId, String commentId) {
    try {
      _firestore
          .collection('MentorPosts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> likeCommentPostMentor(
      String postId, String commentId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore
            .collection('MentorPosts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore
            .collection('MentorPosts')
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
}
