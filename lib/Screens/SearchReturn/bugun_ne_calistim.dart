import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sinavim_app/Widgets/post_card.dart';
import 'package:sinavim_app/Widgets/post_text_card.dart';
import 'package:sinavim_app/services/add_mob_service.dart';

class BugunNeCalistim extends StatefulWidget {
  const BugunNeCalistim({super.key});

  @override
  State<BugunNeCalistim> createState() => _BugunNeCalistimState();
}

class _BugunNeCalistimState extends State<BugunNeCalistim> {
  final ScrollController scrollController = ScrollController();
  BannerAd? _inlineAd;

  @override
  void initState() {
    super.initState();
    //Reklamı Çağırdık
    _createInlineAd();
  }

// Reklam Alanı ----------------
  void _createInlineAd() {
    _inlineAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdmobService.inlineAdUnitedIdtags!,
      listener: AdmobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 1,
        title: Text(
          "Bugün Ne Çalıştım",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('tag', isEqualTo: 'Bugün Ne Çalıştım')
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
              if (index % 4 == 1) {
                return Column(
                  children: [
                    _inlineAd == null
                        ? Container()
                        : Container(
                            alignment: Alignment.center,
                            width: _inlineAd?.size.width.toDouble(),
                            height: _inlineAd?.size.height.toDouble(),
                            child: AdWidget(ad: _inlineAd!),
                          ),
                    snapshot.data!.docs[index].data()["postUrl"] != ""
                        ? PostCard(
                            snap: snapshot.data!.docs[index].data(),
                          )
                        : PostCardText(
                            snap: snapshot.data!.docs[index].data(),
                          ),
                  ],
                );
              } else {
                return snapshot.data!.docs[index].data()["postUrl"] != ""
                    ? PostCard(
                        snap: snapshot.data!.docs[index].data(),
                      )
                    : PostCardText(
                        snap: snapshot.data!.docs[index].data(),
                      );
              }
            },
          );
        },
      ),
    );
  }
}
