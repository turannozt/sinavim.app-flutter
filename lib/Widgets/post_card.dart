// ignore_for_file: prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Resources/firestore_methods.dart';
import 'package:sinavim_app/Screens/Messaging/constant.dart';
import 'package:sinavim_app/Screens/comments_screen.dart';
import 'package:sinavim_app/Screens/profile_screen.dart';
import 'package:sinavim_app/Utils/colors.dart';
import 'package:sinavim_app/Utils/utils.dart';
import 'package:sinavim_app/Widgets/like_animation.dart';
import 'package:sinavim_app/Widgets/like_post.dart';
import 'package:sinavim_app/Widgets/view_post.dart';
import 'package:sinavim_app/models/user.dart' as model;
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:sinavim_app/services/add_mob_service.dart';
import 'package:http/http.dart' as http;

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  InterstitialAd? _interstitialAd;
  int commentLen = 0;
  bool isLikeAnimating = false;
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
    //Reklamı Ekrana Yükleme
    _createIntersitialAd();
    _createRewardedAd();
  }

//Reklam Alanı ----------
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
//Reklam Alanı ----------

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

  bool control = false;
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
    return Column(
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
                          "FXRLWXHsGbOeuhJmTxMnscuUFtv1" //sınavım
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
                                      .toList()),
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
        // IMAGE SECTION OF THE POST
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HeroWidgetPost(
                postUrl: widget.snap['postUrl'],
              ),
            ),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.33,
            width: double.infinity,
            child: Image.network(
              widget.snap['postUrl'].toString(),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // LIKE, COMMENT SECTION OF THE POST
        Row(
          children: <Widget>[
            LikeAnimation(
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
                    FireStoreMethods().likePost(
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
                      builder: (context) => CommentsScreen(
                        userUid: widget.snap['uid'].toString(),
                        token: widget.snap['token'].toString(),
                        postId: widget.snap['postId'].toString(),
                      ),
                    ),
                  );
                  _showRewardedAd();
                }),
            Expanded(child: Container()),
            Row(
              children: [
                user.uid == widget.snap['uid']
                    ? Container()
                    : IconButton(
                        icon: const Image(
                          image: AssetImage('assets/images/stop.png'),
                        ),
                        iconSize: 25,
                        onPressed: () {
                          _showChoiseDialog();
                        },
                      ),
              ],
            ),
            
            IconButton(
                onPressed: () {
                  FireStoreMethods().unfavoriteCard(
                    user.uid,
                    widget.snap['postId'],
                  );
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
                icon: const Icon(Icons.bookmark_remove_outlined)),
            IconButton(
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
                icon: const Icon(Icons.bookmark_add_rounded)),
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.snap['description']}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
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
                        builder: (context) => CommentsScreen(
                          userUid: widget.snap['uid'].toString(),
                          token: widget.snap['token'].toString(),
                          postId: widget.snap['postId'].toString(),
                        ),
                      ),
                    );
                    _showRewardedAd();
                  }),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['datePublished'].toDate()),
                  style: GoogleFonts.openSans(
                    color: secondaryColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}
