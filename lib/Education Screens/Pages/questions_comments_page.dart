import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Education%20Screens/Resources/firestore_methods.dart';
import 'package:sinavim_app/Education%20Screens/Widgets/question_comment_card_widget.dart';
import 'package:sinavim_app/Education%20Screens/Widgets/question_image_comment_card.dart';
import 'package:sinavim_app/Resources/firestore_methods.dart';
import 'package:sinavim_app/Screens/Messaging/constant.dart';
import 'package:sinavim_app/Screens/profile_screen.dart';
import 'package:sinavim_app/Utils/utils.dart';
import 'package:sinavim_app/models/user.dart';
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class QuestionsCommentsScreen extends StatefulWidget {
  final String userUid;
  final String token;
  final String postId;
  const QuestionsCommentsScreen(
      {Key? key,
      required this.postId,
      required this.token,
      required this.userUid})
      : super(key: key);

  @override
  State<QuestionsCommentsScreen> createState() =>
      _QuestionsCommentsScreenState();
}

class _QuestionsCommentsScreenState extends State<QuestionsCommentsScreen> {
  bool isLoading = false;
  final TextEditingController commentEditingController =
      TextEditingController();
  Uint8List? _image;
  Future<String> token() async {
    return await FirebaseMessaging.instance.getToken() ?? "";
  }

  void postComment(
      String uid, String name, String profImage, Uint8List image) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FireStoreQuestionMethods().postCommentImage(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profImage,
        [],
        await token(),
        image,
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
        setState(() {
          isLoading = false;
        });
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
      setState(() {
        isLoading = false;
      });
    }
  }

  void postCommentText(String uid, String name, String profImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FireStoreQuestionMethods().postCommentText(
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
        setState(() {
          isLoading = false;
        });
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
      setState(() {
        isLoading = false;
      });
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(
      const Duration(seconds: 2),
      () {
        setState(() {});
      },
    );
  }

  Future<bool> pushNotificationsSpecificDevice({
    required String token,
    required String title,
    required String body,
  }) async {
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

  final controller = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.extentAfter == 0) {
        controller.jumpTo(controller.position.maxScrollExtent);
      }
    });
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
        title: Text('Yorumlar', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          isLoading
              ? const LinearProgressIndicator()
              : const Padding(padding: EdgeInsets.only(top: 0.0)),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Questions')
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
                  controller: controller,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return snapshot.data!.docs[index].data()["imageUrl"] != ""
                        ? CommentQuestionImageCard(
                            postId: widget.postId,
                            snap: snapshot.data!.docs[index],
                          )
                        : CommentQuestionCard(
                            postId: widget.postId,
                            snap: snapshot.data!.docs[index],
                          );
                  },
                ),
              );
            },
          ),
        ],
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
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => ProfileScreen(uid: user.uid)),
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profImage),
                        radius: 18,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: TextField(
                              keyboardType: TextInputType.text,
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
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.image_outlined,
                        )),
                    InkWell(
                      onTap: () {
                        _image != null
                            ? postComment(
                                user.uid,
                                user.username,
                                user.profImage,
                                _image!,
                              )
                            : postCommentText(
                                user.uid,
                                user.username,
                                user.profImage,
                              );
                        if (user.uid != widget.userUid) {
                          pushNotificationsSpecificDevice(
                            token: widget.token,
                            title: '${user.username} Sorunuza Yanıt Var !',
                            body:
                                'Yanıt İçeriği : ${commentEditingController.text}',
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
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
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
