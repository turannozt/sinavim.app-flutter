// ignore_for_file: prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:provider/provider.dart';
import 'package:sinavim_app/Resources/firestore_methods.dart';
import 'package:sinavim_app/Screens/Messaging/constant.dart';
import 'package:sinavim_app/Screens/comments_screen_text_screen.dart';
import 'package:sinavim_app/Screens/profile_screen.dart';
import 'package:sinavim_app/Utils/colors.dart';
import 'package:sinavim_app/Utils/utils.dart';
import 'package:sinavim_app/Widgets/like_animation.dart';
import 'package:sinavim_app/Widgets/like_post.dart';
import 'package:sinavim_app/models/user.dart' as model;
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:sinavim_app/services/add_mob_service.dart';
import 'package:http/http.dart' as http;

class PostCardText extends StatefulWidget {
  final snap;
  const PostCardText({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCardText> createState() => _PostCardTextState();
}

class _PostCardTextState extends State<PostCardText> {
  InterstitialAd? _interstitialAd;
  int commentLen = 0;
  bool isLikeAnimating = false;
  RewardedAd? _rewardedAd;
  @override
  void initState() {
    super.initState();
    fetchCommentLen();
    _createIntersitialAd();
    _createRewardedAd();
  }

  void _createIntersitialAd() {
    InterstitialAd.load(
      adUnitId: AdmobService.interstitialAdUnitedKullaniciGonderiSildiginde!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null,
      ),
    );
  }

  void _showInterstatialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createIntersitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createIntersitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdmobService.rewardedAdUnitedIdOdulluSkor!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => setState(() => _rewardedAd = ad),
        onAdFailedToLoad: ((error) => setState(() => _rewardedAd = null)),
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createRewardedAd();
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) => setState(() {}),
      );
    }
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
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

  deletePost(String postId, String commentId) async {
    try {
      await FireStoreMethods().deletePost(postId, commentId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
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
    //Gönderi Şikayet
    Future<void> _showChoiseDialog() {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Şikayet Etmek İstediğinizden Emin misiniz ?'),
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
                      FireStoreMethods().reportPost(
                        widget.snap['postId'],
                        widget.snap['description'],
                        widget.snap['postUrl'],
                        widget.snap['uid'],
                        widget.snap['username'],
                        user.uid,
                      );
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: "Şikayetiniz Bildirilmiştir",
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

    List<dynamic> likeList = widget.snap['likes'];
    var isLiked =
        likeList.toList().any((element) => element['uid'].contains(user.uid));
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
                widget.snap['uid'] == 'LFhBwQJng7Zn6BZLHVyvTIPAyvt1' || //Turan
                        widget.snap['uid'] ==
                            'WlCcEFEEtuVsHLk6BW7iegxdHWY2' || //İrem
                        widget.snap['uid'] ==
                            "qbfFV5XOQaY6VIuuOAxz1Mfn7rs2" || //Leyla
                        widget.snap['uid'] ==
                            "QRKSSDFMyESeukqgdlNYkb5guHt2" || //Burak
                        widget.snap['uid'] ==
                            "8qv0YXkXVnYjhudfCch3fx1VaGC2" || //Asuman
                        widget.snap['uid'] ==
                            "FXRLWXHsGbOeuhJmTxMnscuUFtv1" || //sınavım
                        widget.snap['uid'] ==
                            "QBaTtUbO1Bc4Qd9CsX7k21R0fS13" || //Ayşegül
                        widget.snap['uid'] ==
                            "bB0OYUKpuQhPw8BNOQWIhoiziE12" || //nimet
                        widget.snap['uid'] ==
                            "DXvNmVUyHigemLYRQtx5JZq4SCq2" //bilimsel çocuk
                    ? const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/crown.png'),
                        backgroundColor: Colors.transparent,
                        radius: 16,
                      )
                    : Container(),
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
                                    'Gönderiyi Sil',
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
                                              deletePost(
                                                widget.snap['postId']
                                                    .toString(),
                                                widget.snap['commentId']
                                                    .toString(),
                                              );
                                              // remove the dialog box
                                              Navigator.of(context).pop();
                                              Fluttertoast.showToast(
                                                msg: "Gönderiniz Silinmiştir.",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    const Color(0xffd94555),
                                                textColor: Colors.white,
                                                fontSize: 16,
                                              );
                                              _showInterstatialAd();
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
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ),
          // LIKE, COMMENT SECTION OF THE POST
          Row(
            children: <Widget>[
              user.uid == "OpcgCbxGIjZyHYt0MVn71c505E42"
                  ? IconButton(
                      icon: const Icon(Icons.favorite_outline),
                      onPressed: () {
                        Fluttertoast.showToast(
                          msg:
                              "Misafir Hesabındasınız Lütfen Hesap Oluşturun !",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: const Color(0xffd94555),
                          textColor: Colors.white,
                          fontSize: 14,
                        );
                      },
                    )
                  : LikeAnimation(
                      isAnimating: isLiked,
                      smallLike: true,
                      child: IconButton(
                          icon: isLiked
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                ),
                          onPressed: () {
                            FireStoreMethods().likeTextPost(
                              widget.snap['postId'].toString(),
                              user.uid,
                              widget.snap['likes'],
                            );
                            if (widget.snap['uid'] != user.uid) {
                              pushNotificationsSpecificDevice(
                                token: widget.snap['token'],
                                title: 'Yeni Bir Beğeni !',
                                body: '${user.username} Gönderinizi Beğendi',
                              );
                              FireStoreMethods().notificationsCollection(
                                widget.snap['uid'],
                                user.username,
                                'Gönderinizi Beğendi',
                                user.profImage,
                                DateTime.now(),
                              );
                            } else {
                              null;
                            }
                          }),
                    ),
              IconButton(
                icon: const Icon(
                  Icons.comment_outlined,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreenText(
                        userUid: widget.snap['uid'].toString(),
                        token: widget.snap['token'].toString(),
                        postId: widget.snap['postId'].toString(),
                      ),
                    ),
                  );
                  _showRewardedAd();
                },
              ),
              Expanded(child: Container()),
              Row(
                children: [
                  user.uid == widget.snap['uid']
                      ? Container()
                      : IconButton(
                          icon: user.uid == "OpcgCbxGIjZyHYt0MVn71c505E42"
                              ? Container()
                              : Icon(Icons.back_hand_rounded,
                                  color: Colors.green[700]),
                          iconSize: 25,
                          onPressed: () {
                            _showChoiseDialog();
                          },
                        ),
                  user.uid == "OpcgCbxGIjZyHYt0MVn71c505E42"
                      ? Container()
                      : IconButton(
                          onPressed: () {
                            FireStoreMethods().unfavoriteCard(
                                user.uid, widget.snap['postId']);
                            Fluttertoast.showToast(
                              msg: "Gönderi Kayıt Edilenlerden Çıkarıldı",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: const Color(0xffd94555),
                              textColor: Colors.white,
                              fontSize: 16,
                            );
                          },
                          icon: const Icon(Icons.star_border),
                        ),
                  user.uid == "OpcgCbxGIjZyHYt0MVn71c505E42"
                      ? Container()
                      : IconButton(
                          onPressed: () {
                            FireStoreMethods().favoriteCard(
                              user.uid,
                              widget.snap['uid'],
                              widget.snap['postUrl'],
                              widget.snap['description'],
                              widget.snap['postId'],
                              widget.snap['username'],
                              widget.snap['likes'],
                              widget.snap['profImage'],
                              widget.snap['tag'],
                              widget.snap['token'],
                            );
                            Fluttertoast.showToast(
                              msg: "Gönderi Kayıt Edilenlere Eklendi",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: const Color(0xffd94555),
                              textColor: Colors.white,
                              fontSize: 16,
                            );
                          },
                          icon: const Icon(Icons.star)),
                ],
              )
            ],
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultTextStyle(
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostLike(
                            uid: widget.snap['postId'],
                          ),
                        ),
                      );
                    },
                    child: Text(
                      '${widget.snap['likes'].length} Beğenme',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Toplam $commentLen yorum',
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsScreenText(
                            userUid: widget.snap['uid'].toString(),
                            token: widget.snap['token'].toString(),
                            postId: widget.snap['postId'].toString(),
                          ),
                        ),
                      );
                      _showRewardedAd();
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.snap['tag'] == "null"
                        ? Container()
                        : Text(
                            '#${widget.snap["tag"]}',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.green[800],
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                  ],
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
