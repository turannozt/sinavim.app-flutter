import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Education%20Screens/Pages/add_question_page.dart';
import 'package:sinavim_app/Education%20Screens/Pages/add_question_text_page.dart';
import 'package:sinavim_app/Utils/utils.dart';
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:sinavim_app/models/user.dart' as model;
import 'package:sinavim_app/services/add_mob_service.dart';
import 'components/appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  int _rewardedAdScore = 0;
  bool rmIcons = false;
  bool isLoading = false;
  int postLenMath = 0;
  int postLenTurce = 0;
  int postLenfkb = 0;
  int postLensosyal = 0;
  int postLenIng = 0;
  void textPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddQuestionTextScreen(),
      ),
    ).then((value) => setState(() {}));
    _showInterstatialAd();
  }

  void imagePost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddQuestionPage(),
      ),
    ).then((value) => setState(() {}));
    _showInterstatialAd();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      // get Math post lENGTH
      var postSnapMat = await FirebaseFirestore.instance
          .collection('Questions')
          .where('tag', isEqualTo: 'Matematik')
          .get();
      postLenMath = postSnapMat.docs.length;

      var postSnapTurkce = await FirebaseFirestore.instance
          .collection('Questions')
          .where('tag', isEqualTo: 'Türkçe/Dil Bilgisi')
          .get();
      postLenTurce = postSnapTurkce.docs.length;

      var postSnapfkb = await FirebaseFirestore.instance
          .collection('Questions')
          .where('tag', isEqualTo: 'F-K-B')
          .get();
      postLenfkb = postSnapfkb.docs.length;

      var postSnapsosyal = await FirebaseFirestore.instance
          .collection('Questions')
          .where('tag', isEqualTo: 'Sosyal')
          .get();
      postLensosyal = postSnapsosyal.docs.length;

      var postSnapIng = await FirebaseFirestore.instance
          .collection('Questions')
          .where('tag', isEqualTo: 'İngilizce')
          .get();
      postLenIng = postSnapIng.docs.length;

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
  void initState() {
    super.initState();
    getData();
    _createRewardedAd();
    _createIntersitialAd();
  }

//Reklam Alanıı
  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdmobService.rewardedAdUnitedIdSoruSorEkraniDersler!,
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
        onUserEarnedReward: (ad, reward) => setState(() => _rewardedAdScore++),
      );
    }
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

//Reklam Alanı
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      //bottom bar
      // now we will use bottom bar package
      body: SafeArea(
        child: ListView(
          children: [
            const CustomeAppBar(),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Merhaba ${user.username}",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            "Sorularının Yanıtlarını Burada Bulabilirsin.",
                            style: TextStyle(
                              wordSpacing: 2.5,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          user.profImage.toString(),
                        ),
                        radius: 40,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/all-questions');
                      _showRewardedAd();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.pink[700],
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text(
                        "Tüm Sorular",
                        style: GoogleFonts.openSans(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  //category list
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Kategoriler",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      questionCards(
                        onClick: () {
                          Navigator.pushNamed(context, '/math');
                          _showRewardedAd();
                        },
                        imageUrl: 'assets/images/graphics.png',
                        title: 'Matematik TYT-AYT ',
                        questionNumber: postLenMath,
                        color: const Color(0xFF71b8ff),
                      ),
                      questionCards(
                        onClick: () {
                          Navigator.pushNamed(context, '/turkish');
                          _showRewardedAd();
                        },
                        imageUrl: 'assets/images/programming.png',
                        title: 'Türkçe - Dil Bilgisi',
                        questionNumber: postLenTurce,
                        color: const Color(0xFFff6374),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      questionCards(
                        onClick: () {
                          Navigator.pushNamed(context, '/fkb');
                          _showRewardedAd();
                        },
                        imageUrl: "assets/images/finance.png",
                        title: 'Fizik - Kimya - Biyoloji',
                        questionNumber: postLenfkb,
                        color: const Color(0xFFffaa5b),
                      ),
                      questionCards(
                        onClick: () {
                          Navigator.pushNamed(context, '/social');
                          _showRewardedAd();
                        },
                        imageUrl: 'assets/images/programming.png',
                        title: 'Tarih - Coğrafya - Felsefe',
                        questionNumber: postLensosyal,
                        color: const Color(0xFF9ba0fc),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 6),
                      questionCards(
                        onClick: () {
                          Navigator.pushNamed(context, '/english');
                          _showRewardedAd();
                        },
                        imageUrl: "assets/images/Thesis-pana.png",
                        title: 'İngilizce - YDT',
                        questionNumber: postLenIng,
                        color: const Color.fromARGB(255, 181, 106, 199),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: const Color(0xffd94555),
        icon: Icons.question_mark,
        label: Text(
          'Soru Sor',
          style: GoogleFonts.openSans(
              fontWeight: FontWeight.w600, color: Colors.white),
        ),
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
            child: !rmIcons ? const Icon(Icons.photo_library) : null,
            backgroundColor: const Color(0xff801818),
            foregroundColor: Colors.white,
            onTap: imagePost,
            label: 'Soru Sor (Foto)',
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          SpeedDialChild(
            child: !rmIcons ? const Icon(Icons.question_answer) : null,
            backgroundColor: const Color(0xff801818),
            foregroundColor: Colors.white,
            onTap: textPost,
            label: 'Soru Sor (Yazılı)',
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget questionCards({
    required String imageUrl,
    required String title,
    required int questionNumber,
    required Color color,
    required VoidCallback onClick,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 150,
          height: 200,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            children: [
              Image.asset(
                imageUrl,
                height: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "$questionNumber Soru",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
