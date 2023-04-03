import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sinavim_app/Resources/storage_methods.dart';
import 'package:sinavim_app/models/question.dart';
import 'package:uuid/uuid.dart';

class FireStoreQuestionMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //  fotoğraflı Soru
  Future<String> uploadQuestin(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
    String tag,
    String token,
  ) async {
    String res = "Some error occurred";
    try {
      String postUrl =
          await StorageMethods().uploadImageToStorage('Questions', file, true);
      String questionId = const Uuid().v1(); // creates unique id based on time
      Question question = Question(
        savedControl: false,
        token: token,
        tag: tag,
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: questionId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profImage: profImage,
      );
      _firestore.collection('Questions').doc(questionId).set(question.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //  yazılı gönderi
  Future<String> uploadQuestinText(String description, String uid,
      String username, String profImage, String tag, String token) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String questionId = const Uuid().v1(); // creates unique id based on time
      Question question = Question(
        savedControl: false,
        token: token,
        tag: tag,
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: questionId,
        datePublished: DateTime.now(),
        postUrl: '',
        profImage: profImage,
      );
      _firestore.collection('Questions').doc(questionId).set(question.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('Questions').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('Questions').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePostText(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('Questions').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('Questions').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// fotoğraflı gönderi yorumu Image olan
  Future<String> postCommentImage(
    String postId,
    String text,
    String uid,
    String name,
    String profImage,
    List likes,
    String token,
    Uint8List file,
  ) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String imageUrl = await StorageMethods()
            .uploadImageToStorage('Questions', file, true);
        String commentId = const Uuid().v1();
        _firestore
            .collection('Questions')
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
          'token': token,
          'imageUrl': imageUrl
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

// fotoğraflı gönderi yorumu Text olan
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
            .collection('Questions')
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
          'token': token,
          'imageUrl': ''
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

// fotoğraflı gönderi yorumu Image olan
  Future<String> questionCommentImage(
    String postId,
    String text,
    String uid,
    String name,
    String profImage,
    List likes,
    String token,
    Uint8List file,
  ) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String imageUrl = await StorageMethods()
            .uploadImageToStorage('Questions', file, true);
        String commentId = const Uuid().v1();
        _firestore
            .collection('Questions')
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
          'token': token,
          'imageUrl': imageUrl
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

// fotoğraflı gönderi yorumu Text olan
  Future<String> questionCommentText(
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
            .collection('Questions')
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
          'token': token,
          'imageUrl': ''
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

//comment like
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
            .collection('Questions')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore
            .collection('Questions')
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

//YORUM SİL
  deleteComment(String postId, String commentId) {
    try {
      _firestore
          .collection('Questions')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Delete Post
  Future<String> deletePost(String questionId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('Questions').doc(questionId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
