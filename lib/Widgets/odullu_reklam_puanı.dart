// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sinavim_app/services/add_mob_service.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  RewardedAd? _rewardedAd;
  int _rewardedAdScore = 0;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();

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
        onUserEarnedReward: (ad, reward) => setState(() {
          _rewardedAdScore++;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          'Rozet Oyunu',
          style: Theme.of(context).textTheme.headline5,
        ),
        elevation: 1,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Geliştirilme Aşamasındadır Bu Özellik Gelene Kadar Reklam İzleyerek Bizlere Destek Olabilirsiniz.',
                  style: GoogleFonts.openSans(
                      fontSize: 16, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rozet Oyunu Bilgi',
                    style: GoogleFonts.openSans(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                                "Nasıl rozet alabilirim ? Rozet ne işe yarar ? "),
                            content: Text(
                              "•Rozet kullanıcının aktifliğini belli eden ve diğer kullanıcılar arasında ön plana çıkmayı sağlayan bir simgedir.  Eğer kullanıcılar 7 gün boyun günde 10 adet reklam izlerse tıpkı yönetici, mod veya mentorlerdekine benzer küçük bir simge kullanıcı adına gelir.",
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                wordSpacing: 1,
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text(
                                  "Sınavım'da Ön Plana Çıkmak Nedir ?",
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Sınavımda ön plana çıkmak kullanıcılara ne katkı sağlar ?"),
                                        content: Text(
                                          "•Gönderilerinin öne çıkmasını gönderilerinin daha çok yanıtlanmasını ve diğer kullanıcılar arasında kolaylıkla gönderilerinin fark edilmesini sağlar.",
                                          style: GoogleFonts.openSans(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            wordSpacing: 1,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: const Text("Anladım"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              ElevatedButton(
                                child: const Text("Tamam"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.info),
                  ),
                ],
              ),
              Flexible(flex: 2, child: Container()),
              IconButton(
                onPressed: _showInterstatialAd,
                icon: const Icon(
                  Icons.ads_click,
                  size: 25,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xffd94555),
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: const Size(200, 30),
                ),
                onPressed: _showRewardedAd,
                child: Text(
                  'Ödüllü Reklam Skoru : $_rewardedAdScore',
                  style: GoogleFonts.openSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Flexible(flex: 2, child: Container())
            ],
          ),
        ),
      ),
    );
  }
}
