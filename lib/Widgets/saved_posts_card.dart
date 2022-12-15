import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sinavim_app/Widgets/post_card.dart';
import 'package:sinavim_app/Widgets/post_text_card.dart';
import 'package:sinavim_app/services/add_mob_service.dart';

class SavedPosts extends StatefulWidget {
  final String uid;
  const SavedPosts({Key? key, required this.uid}) : super(key: key);

  @override
  State<SavedPosts> createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  BannerAd? _banner;
  Future<void> _handleRefresh() async {
    return await Future.delayed(
      const Duration(seconds: 2),
      () {
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdmobService.bannnerAdUnitedGonderiOlusturmaEkranlariAltinda!,
      listener: AdmobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          'Kaydedilenler',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .collection('favoriteCard')
            .orderBy('datePublished', descending: true)
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

          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
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
              itemBuilder: (ctx, index) =>
                  snapshot.data!.docs[index].data()["postUrl"] != ""
                      ? PostCard(
                          snap: snapshot.data!.docs[index].data(),
                        )
                      : PostCardText(
                          snap: snapshot.data!.docs[index].data(),
                        ),
            ),
          );
        },
      ),
      bottomNavigationBar: _banner == null
          ? Container()
          : Container(
              padding: const EdgeInsets.only(bottom: 4),
              width: double.infinity,
              height: 52,
              child: AdWidget(ad: _banner!),
            ),
    );
  }
}
