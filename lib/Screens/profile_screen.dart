import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Resources/firestore_methods.dart';
import 'package:sinavim_app/Screens/edit_profile_screen.dart';
import 'package:sinavim_app/Utils/utils.dart';
import 'package:sinavim_app/Widgets/odullu_reklam_puan%C4%B1.dart';
import 'package:sinavim_app/Widgets/follow_button_widget.dart';
import 'package:sinavim_app/Widgets/followers_card.dart';
import 'package:sinavim_app/Widgets/following_card.dart';
import 'package:sinavim_app/Widgets/post_card.dart';
import 'package:sinavim_app/Widgets/post_text_card.dart';
import 'package:sinavim_app/Widgets/view_profil_photo.dart';
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:sinavim_app/models/user.dart' as model;

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool rmIcons = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
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
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;

      List checkList = (userSnap.data()! as dynamic)['followers'];

      isFollowing = checkList.toList().any((element) =>
          element['uid'].contains(FirebaseAuth.instance.currentUser!.uid));
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

  void editProfill() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfil(
          uid: userData['uid'],
        ),
      ),
    ).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return isLoading
        ? const Center(
            child: SpinKitCircle(
              color: Colors.green,
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 1,
              title: Row(
                children: [
                  Text(
                    userData['username'],
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(width: 5),
                  userData['uid'] ==
                              "LFhBwQJng7Zn6BZLHVyvTIPAyvt1" || //Turan Mod Mentor
                          userData['uid'] ==
                              "WlCcEFEEtuVsHLk6BW7iegxdHWY2" || //İrem Mentor
                          userData['uid'] ==
                              "QRKSSDFMyESeukqgdlNYkb5guHt2" || //Burak Mod
                          userData['uid'] ==
                              "8qv0YXkXVnYjhudfCch3fx1VaGC2" || //Asuman Mentor
                          userData['uid'] ==
                              "qbfFV5XOQaY6VIuuOAxz1Mfn7rs2" || // Leyla
                          userData['uid'] ==
                              "FXRLWXHsGbOeuhJmTxMnscuUFtv1" //sınavım
                      ? const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/crown.png'),
                          backgroundColor: Colors.transparent,
                          radius: 18,
                        )
                      : Container()
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DonatePage(),
                    ),
                  ),
                  icon: const Icon(Icons.ads_click_outlined),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(160.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HeroWidget(
                                  profImage: userData['profImage'].toString(),
                                ),
                              ),
                            ),
                            child: Hero(
                              tag: 'profImage',
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                  userData['profImage'],
                                ),
                                radius: 40,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "Gönderi"),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Followers(uid: userData['uid']),
                                        ),
                                      ),
                                      child: buildStatColumn(
                                        followers,
                                        "Takipçi",
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Following(uid: userData['uid']),
                                        ),
                                      ),
                                      child:
                                          buildStatColumn(following, "Takip"),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? Container()
                                        : isFollowing
                                            ? FollowButtonCard(
                                                title: 'Takipten Çık',
                                                onPressed: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );
                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                })
                                            : FollowButtonCard(
                                                title: 'Takip Et',
                                                onPressed: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: Text(
                              userData['username'],
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              userData['bio'],
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: user.engelkontrol == "false"
                ? DefaultTabController(
                    initialIndex: 0,
                    length: 2,
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text(
                          'Gönderiler',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        centerTitle: true,
                        leading: Container(),
                        elevation: 0,
                        bottom: const TabBar(
                          tabs: [
                            Tab(
                              icon: Icon(
                                Icons.apps_rounded,
                                color: Colors.teal,
                              ),
                            ),
                            Tab(
                              icon: Icon(
                                Icons.article_rounded,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          postsPic(),
                          postsText(),
                        ],
                      ),
                    ),
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
            floatingActionButton: userData['uid'] == user.uid
                ? SpeedDial(
                    backgroundColor: const Color(0xffd94555),
                    icon: Icons.menu,
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
                        child: !rmIcons ? const Icon(Icons.settings) : null,
                        backgroundColor: const Color(0xff801818),
                        foregroundColor: Colors.white,
                        onTap: editProfill,
                        label: 'Ayarlar',
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                : Container(),
          );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> postsPic() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .orderBy('datePublished', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitCircle(
              color: Colors.green,
            ),
          );
        }
        return ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return snapshot.data!.docs[index].data()["postUrl"] != ""
                ? PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  )
                : Container();
            // : PostCardText(
            //     snap: snapshot.data!.docs[index].data(),
            //   );
          },
        );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> postsText() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .orderBy('datePublished', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitCircle(
              color: Colors.green,
            ),
          );
        }
        return ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return snapshot.data!.docs[index].data()["postUrl"] == ""
                ? PostCardText(
                    snap: snapshot.data!.docs[index].data(),
                  )
                : Container();

            // : PostCardText(
            //     snap: snapshot.data!.docs[index].data(),
            //   );
          },
        );
      },
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
