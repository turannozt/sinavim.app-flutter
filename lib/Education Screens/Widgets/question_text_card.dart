// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Education%20Screens/Pages/questions_comments_page.dart';
import 'package:sinavim_app/Education%20Screens/Resources/firestore_methods.dart';
import 'package:sinavim_app/Resources/firestore_methods.dart';
import 'package:sinavim_app/Screens/Messaging/constant.dart';
import 'package:sinavim_app/Screens/profile_screen.dart';
import 'package:sinavim_app/Utils/colors.dart';
import 'package:sinavim_app/Utils/utils.dart';
import 'package:sinavim_app/Widgets/like_animation.dart';
import 'package:sinavim_app/models/user.dart' as model;
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class QuestionTextCard extends StatefulWidget {
  final snap;
  const QuestionTextCard({super.key, this.snap});

  @override
  State<QuestionTextCard> createState() => _QuestionTextCardState();
}

class _QuestionTextCardState extends State<QuestionTextCard> {
  int commentLen = 0;

  deletePost(String questionId) async {
    try {
      await FireStoreQuestionMethods().deletePost(questionId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('Questions')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
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

  @override
  Widget build(BuildContext context) {
    var paylasimZamani = DateTime.now();
    var ekranYuklemeZamani = widget.snap['datePublished'].toDate();

    var snOnce = paylasimZamani.difference(ekranYuklemeZamani).inSeconds;

    Widget zaman(int fark) {
      if (fark <= 60) {
        return Text(
          '$fark Saniye Önce',
          style: GoogleFonts.sourceSansPro(
              fontSize: 13, fontWeight: FontWeight.w500),
        );
      } else if (fark <= 3600) {
        return Text('${(fark / 60).floor()} Dakika Önce',
            style: GoogleFonts.openSans(
                fontSize: 13, fontWeight: FontWeight.w500));
      } else if (fark <= 86400) {
        return Text('${(fark / 3600).floor()} Saat Önce',
            style: GoogleFonts.openSans(
                fontSize: 13, fontWeight: FontWeight.w500));
      } else {
        return Text('${(fark / 86400).floor()} Gün Önce',
            style: GoogleFonts.openSans(
                fontSize: 13, fontWeight: FontWeight.w500));
      }
    }

    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      // boundary needed for web
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 8,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: widget.snap["uid"],
                      ),
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 16,
                    backgroundImage: NetworkImage(
                      widget.snap['profImage'].toString(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          uid: widget.snap["uid"],
                        ),
                      ),
                    ),
                    child: Text(
                      widget.snap['username'].toString(),
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  width: double.infinity,
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: zaman(snOnce),
                ),
                user.uid == widget.snap['uid'].toString() // kenndisi
                        ||
                        user.uid == "LFhBwQJng7Zn6BZLHVyvTIPAyvt1" //Turan
                        ||
                        user.uid == "QRKSSDFMyESeukqgdlNYkb5guHt2" // Burak
                        ||
                        user.uid == "qbfFV5XOQaY6VIuuOAxz1Mfn7rs2" || //Leyla
                        user.uid == "FXRLWXHsGbOeuhJmTxMnscuUFtv1" //sınavım
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: [
                                    'Soruyu Sil',
                                  ]
                                      .map(
                                        (e) => InkWell(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                            onTap: () {
                                              deletePost(widget.snap['postId']
                                                  .toString());
                                              // remove the dialog box
                                              Navigator.of(context).pop();
                                              Fluttertoast.showToast(
                                                msg: "Sorunuz Silinmiştir.",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    const Color(0xffd94555),
                                                textColor: Colors.white,
                                                fontSize: 16,
                                              );
                                            }),
                                      )
                                      .toList(),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    : Container(),
              ],
            ),
          ),
          // descriptin
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 5, top: 4, bottom: 4),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: primaryColor),
                children: [
                  TextSpan(
                    text: ' ${widget.snap['description']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          // LIKE, COMMENT SECTION OF THE POST
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.comment_outlined,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuestionsCommentsScreen(
                        userUid: widget.snap['uid'].toString(),
                        token: widget.snap['token'].toString(),
                        postId: widget.snap['postId'].toString(),
                      ),
                    ),
                  );
                },
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Toplam $commentLen yorum',
                    style: GoogleFonts.openSans(
                      fontSize: 15,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuestionsCommentsScreen(
                        userUid: widget.snap['uid'].toString(),
                        token: widget.snap['token'].toString(),
                        postId: widget.snap['postId'].toString(),
                      ),
                    ),
                  );
                },
              ),
              Expanded(child: Container()),
              DefaultTextStyle(
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w800),
                child: Text(
                  '${widget.snap['likes'].length} Yıldız',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Icon(
                            size: 26,
                            Icons.star,
                            color: Colors.red,
                          )
                        : const Icon(
                            size: 26,
                            Icons.star_border,
                          ),
                    onPressed: () {
                      FireStoreQuestionMethods().likePostText(
                        widget.snap['postId'].toString(),
                        user.uid,
                        widget.snap['likes'],
                      );
                      if (widget.snap['uid'] != user.uid) {
                        pushNotificationsSpecificDevice(
                          token: widget.snap['token'],
                          title: 'Yeni Bir Yıldız !',
                          body: '${user.username} Sorunuzu Yıldızladı 😎',
                        );
                        FireStoreMethods().notificationsCollection(
                          widget.snap['uid'],
                          user.username,
                          'Sorunuzu Yıldızladı 😎',
                          user.profImage,
                          DateTime.now(),
                        );
                      } else {
                        null;
                      }
                    }),
              ),
            ],
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: GoogleFonts.openSans(
                      color: secondaryColor,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  '#${widget.snap["tag"]}',
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Colors.pink[700],
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1)
        ],
      ),
    );
  }
}
