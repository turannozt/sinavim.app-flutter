import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Resources/firestore_methods.dart';
import 'package:sinavim_app/Screens/add_post_screen.dart';
import 'package:sinavim_app/Screens/add_user_text_post_screen.dart';
import 'package:sinavim_app/Screens/notifications_screen.dart';
import 'package:sinavim_app/Widgets/feed_screen_appbar_title.dart';
import 'package:sinavim_app/Widgets/follow_button_widget.dart';
import 'package:sinavim_app/Widgets/post_card.dart';
import 'package:sinavim_app/Widgets/post_text_card.dart';
import 'package:sinavim_app/Widgets/saved_posts_card.dart';
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:sinavim_app/services/add_mob_service.dart';
import 'package:sinavim_app/services/firebase_service.dart';
import 'package:sinavim_app/models/user.dart' as model;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  BannerAd? _inlineAd;
  bool rmIcons = false;
  RewardedAd? _rewardedAd;
  Future<void> _handleRefresh() async {
    return await Future.delayed(
      const Duration(seconds: 2),
      () {
        setState(() {});
      },
    );
  }

  Future<String> token() async {
    return await FirebaseMessaging.instance.getToken() ?? "";
  }

  void textPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddUserTextPostScreen(),
      ),
    ).then((value) => setState(() {}));
  }

  void imagePost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPostScreen(),
      ),
    ).then((value) => setState(() {}));
  }

  final _service = FirebaseNotificationService();

  @override
  void initState() {
    super.initState();
    _service.connectNotification();
    //Reklamı Çağırdık
    _createInlineAd();
    tokenUpdate();
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

// Reklam Alanı ----------------
  void _createInlineAd() {
    _inlineAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdmobService.inlineAdUnitedFeedScreenGonderileri!,
      listener: AdmobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  void tokenUpdate() async {
    FireStoreMethods().tokenUpdate(
      FirebaseAuth.instance.currentUser!.uid,
      await token(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_active,
              size: 25,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedPosts(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  ),
                ),
              );
              _showRewardedAd();
            },
            icon: const Icon(
              CupertinoIcons.bookmark_solid,
              size: 22,
            ),
          ),
        ],
        elevation: 0,
        centerTitle: false,
        title: const AnimationTextHeadFeed(),
      ),
      body: Column(
        children: [
          Flexible(
            child: user.engelkontrol == "false"
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .orderBy('datePublished', descending: true)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitCircle(
                            color: Colors.green,
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }
                      // ignore: unrelated_type_equality_checks
                      if (snapshot.connectionState == ConnectionState.values) {
                        return const Center(
                          child: SpinKitCircle(
                            color: Colors.green,
                          ),
                        );
                      }
                      return RefreshIndicator(
                        color: Colors.red,
                        onRefresh: _handleRefresh,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) {
                            if (index % 4 == 1) {
                              return Column(
                                children: [
                                  _inlineAd == null
                                      ? Container()
                                      : Container(
                                          alignment: Alignment.center,
                                          width:
                                              _inlineAd?.size.width.toDouble(),
                                          height:
                                              _inlineAd?.size.height.toDouble(),
                                          child: AdWidget(ad: _inlineAd!),
                                        ),
                                  snapshot.data!.docs[index]
                                              .data()["postUrl"] !=
                                          ""
                                      ? PostCard(
                                          snap:
                                              snapshot.data!.docs[index].data(),
                                        )
                                      : PostCardText(
                                          snap:
                                              snapshot.data!.docs[index].data(),
                                        ),
                                ],
                              );
                            } else {
                              return snapshot.data!.docs[index]
                                          .data()["postUrl"] !=
                                      ""
                                  ? PostCard(
                                      snap: snapshot.data!.docs[index].data(),
                                    )
                                  : PostCardText(
                                      snap: snapshot.data!.docs[index].data(),
                                    );
                            }
                          },
                        ),
                      );
                    },
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Oh no-amico.png',
                        width: double.infinity,
                        height: 300,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${user.username} Hesabınız Kurallara Uymadığınız Geçici Süreliğine Engellendi. Engel Sebebini Öğrenmek İçin İletişime Geçebilirsiniz.',
                          style: GoogleFonts.openSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            wordSpacing: 1,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      FollowButtonCard(
                        title: "İletişime Geç",
                        onPressed: () =>
                            Navigator.pushNamed(context, '/feedback-card'),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: user.engelkontrol == "false"
          ? SpeedDial(
              backgroundColor: const Color(0xffd94555),
              icon: Icons.add,
              iconTheme: const IconThemeData(color: Colors.white),
              activeIcon: Icons.close,
              spacing: 30,
              childPadding: const EdgeInsets.all(5),
              buttonSize: const Size.fromRadius(28),
              spaceBetweenChildren: 4,
              childrenButtonSize: const Size.fromRadius(28),
              visible: true,
              direction: SpeedDialDirection.up,
              useRotationAnimation: true,
              elevation: 0.1,
              animationCurve: Curves.elasticInOut,
              isOpenOnStart: false,
              animationDuration: const Duration(milliseconds: 300),
              children: [
                SpeedDialChild(
                  child:
                      !rmIcons ? const Icon(Icons.add_a_photo_outlined) : null,
                  backgroundColor: const Color(0xff801818),
                  foregroundColor: Colors.white,
                  onTap: imagePost,
                  label: 'Gönderi Oluştur',
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                SpeedDialChild(
                  child: !rmIcons ? const Icon(Icons.edit_note_sharp) : null,
                  backgroundColor: const Color(0xff801818),
                  foregroundColor: Colors.white,
                  onTap: textPost,
                  label: 'Düşüncelerini Paylaş',
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            )
          : Container(),
    );
  }
}
