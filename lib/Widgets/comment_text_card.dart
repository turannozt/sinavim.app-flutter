// ignore_for_file: prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Resources/firestore_methods.dart';
import 'package:sinavim_app/Screens/Messaging/constant.dart';
import 'package:sinavim_app/Screens/profile_screen.dart';
import 'package:sinavim_app/Utils/utils.dart';
import 'package:sinavim_app/Widgets/like_animation.dart';
import 'package:sinavim_app/models/user.dart' as model;
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class CommentCardText extends StatefulWidget {
  final snap;
  final String postId;
  const CommentCardText({Key? key, required this.snap, required this.postId})
      : super(key: key);

  @override
  State<CommentCardText> createState() => _CommentCardTextState();
}

class _CommentCardTextState extends State<CommentCardText> {
  var userData = {};
  bool isLoading = false;
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

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;

      setState(
        () {},
      );
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var paylasimZamani = widget.snap.data()['datePublished'].toDate();
    var ekranYuklemeZamani = DateTime.now();
    var snOnce = ekranYuklemeZamani.difference(paylasimZamani).inSeconds;

    Widget zaman(int fark) {
      if (fark <= 60) {
        return Text('$fark sn');
      } else if (fark <= 3600) {
        return Text('${(fark / 60).floor()} d');
      } else if (fark <= 86400) {
        return Text('${(fark / 3600).floor()} s');
      } else {
        return Text('${(fark / 86400).floor()} g');
      }
    }

    Future<void> _showChoiseDialog() {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                  'Yorumunuzu silmek isetediğinizden emin misiniz ?'),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      FireStoreMethods().deleteComment(
                          widget.postId, widget.snap.data()['commentId']);
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: "Yorumunuz Silinmiştir.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: const Color(0xffd94555),
                        textColor: Colors.white,
                        fontSize: 14,
                      );
                    },
                    child: const Text('Evet'),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Hayır'),
                  ),
                ],
              ),
            );
          });
    }

    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: InkWell(
        onDoubleTap: () => user.uid == widget.snap['uid'] ||
                user.uid == "LFhBwQJng7Zn6BZLHVyvTIPAyvt1" || //Turan
                user.uid == "qbfFV5XOQaY6VIuuOAxz1Mfn7rs2" || //Leyla
                user.uid == "QRKSSDFMyESeukqgdlNYkb5guHt2" || //Burak
                user.uid == "FXRLWXHsGbOeuhJmTxMnscuUFtv1" //sınavım

            ? _showChoiseDialog()
            : null,
        child: Row(
          children: [
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    uid: widget.snap["uid"],
                  ),
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  user.uid == widget.snap.data()['uid']
                      ? user.profImage
                      : widget.snap.data()['profImage'],
                ),
                radius: 18,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: user.uid == widget.snap.data()['uid']
                                ? user.username
                                : widget.snap.data()['name'],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text: ' ${widget.snap.data()['text']}',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: zaman(snOnce),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 10),
                          child: GestureDetector(
                            onTap: () {},
                            child: GestureDetector(
                              onTap: () async {
                                if (user.uid != widget.snap.data()['uid']) {
                                  await pushNotificationsSpecificDevice(
                                    token: widget.snap.data()['token'],
                                    title:
                                        'Yorumuna Yanıt Veren Birileri Var !',
                                    body:
                                        '${widget.snap.data()['text']} İçerkli Yorumuna Bir Yanıt Var',
                                  );
                                  Fluttertoast.showToast(
                                    msg:
                                        "Kullanıcı Yorumunuzdan Haberdar Oldu !",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: const Color(0xffd94555),
                                    textColor: Colors.white,
                                    fontSize: 14,
                                  );
                                }
                              },
                              child: const Text(
                                'Yanıtla',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                LikeAnimation(
                  isAnimating: widget.snap.data()['likes'].contains(user.uid),
                  smallLike: true,
                  child: IconButton(
                    icon: widget.snap.data()['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.pink,
                            size: 22,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            size: 22,
                          ),
                    onPressed: () => FireStoreMethods().likeCommentPost(
                      widget.postId,
                      widget.snap.data()['commentId'],
                      user.uid,
                      widget.snap.data()['likes'],
                    ),
                  ),
                ),
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap.data()['likes'].length}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
