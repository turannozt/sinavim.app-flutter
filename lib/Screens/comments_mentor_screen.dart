import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Resources/firestore_methods.dart';
import 'package:sinavim_app/Resources/firestore_methods_mentor.dart';
import 'package:sinavim_app/Screens/Messaging/constant.dart';
import 'package:sinavim_app/Widgets/mentor_comment_card.dart';
import 'package:sinavim_app/models/user.dart';
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class CommentsMentorScreen extends StatefulWidget {
  final String userUid;
  final String token;
  final String postId;
  const CommentsMentorScreen(
      {Key? key,
      required this.postId,
      required this.token,
      required this.userUid})
      : super(key: key);

  @override
  State<CommentsMentorScreen> createState() => _CommentsMentorScreenState();
}

class _CommentsMentorScreenState extends State<CommentsMentorScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();
  Future<String> token() async {
    return await FirebaseMessaging.instance.getToken() ?? "";
  }

  Future<bool> pushNotificationsSpecificDevice(
      {required String token,
      required String title,
      required String body,
      required String page}) async {
    String dataNotifications = '{ "to" : "$token",'
        ' "notification" : {'
        ' "title":"$title",'
        '"body":"$body"'
        ' }'
        ' }';

    await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    return true;
  }

  void postComment(String uid, String name, String profImage) async {
    try {
      String res = await FireStoreMethodsMentor().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profImage,
        [],
        await token(),
      );

      if (res != 'success') {
        Fluttertoast.showToast(
          msg: "Hata",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffd94555),
          textColor: Colors.white,
          fontSize: 14,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Yorum Paylaşıldı",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffd94555),
          textColor: Colors.white,
          fontSize: 14,
        );
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(
      const Duration(seconds: 2),
      () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        elevation: 1,
        title: Text('Yorumlar', style: Theme.of(context).textTheme.headline6),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('MentorPosts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('datePublished', descending: false)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitCircle(
                color: Colors.green,
              ),
            );
          }
          return RefreshIndicator(
            color: Colors.green,
            onRefresh: _handleRefresh,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => MentorCommentCard(
                postId: widget.postId,
                snap: snapshot.data!.docs[index],
              ),
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: user.uid == "OpcgCbxGIjZyHYt0MVn71c505E42"
              ? Container()
              : Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profImage),
                      radius: 18,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: TextField(
                          autocorrect: true,
                          controller: commentEditingController,
                          decoration: InputDecoration(
                            labelText: 'Metin Giriniz',
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              wordSpacing: 1,
                              letterSpacing: 1,
                            ),
                            hintText: 'Yorum Yapan ${user.username}',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        postComment(
                          user.uid,
                          user.username,
                          user.profImage,
                        );
                        if (user.uid != widget.userUid) {
                          pushNotificationsSpecificDevice(
                            token: widget.token,
                            title: '${user.username} Gönderinize Yorum Yaptı',
                            body:
                                'Yorum İçeriği : ${commentEditingController.text}',
                            page: "",
                          );
                          FireStoreMethods().notificationsCollection(
                            widget.userUid,
                            user.username,
                            commentEditingController.text,
                            user.profImage,
                            DateTime.now(),
                          );
                        } else {
                          null;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: const Text(
                          'Gönder',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
