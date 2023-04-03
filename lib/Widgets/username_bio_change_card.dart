// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:provider/provider.dart';
import 'package:sinavim_app/Resources/firestore_methods.dart';
import 'package:sinavim_app/Widgets/text_field_input.dart';
import 'package:sinavim_app/models/user.dart' as model;
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:sinavim_app/services/add_mob_service.dart';

class UsernameBioChange extends StatefulWidget {
  final snap;
  const UsernameBioChange({Key? key, this.snap}) : super(key: key);
  @override
  State<UsernameBioChange> createState() => _UsernameBioChangeState();
}

class _UsernameBioChangeState extends State<UsernameBioChange> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool isLoading = false;
  RewardedAd? _rewardedAd;
  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  @override
  void initState() {
    super.initState();
      //Reklam Çağırdık
    _createRewardedAd();
  }
// Reklam Alanı ----------------------
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
// Reklam Alanı ----------------------
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    changeBioUsername() {
      if (_bioController.text != "" || _usernameController.text != "") {
        FireStoreMethods().dataBioUpdate(user.uid, _bioController.text);
        isLoading = true;
        Fluttertoast.showToast(
          msg: "Bilgileriniz Güncellenmiştir.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffd94555),
          textColor: Colors.white,
          fontSize: 14,
        );
        _showRewardedAd();
      } else {
        Fluttertoast.showToast(
          msg: "Alanları Boş Bırakmayınız !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffd94555),
          textColor: Colors.white,
          fontSize: 14,
        );
      }

      if (_usernameController.text != "" || _bioController.text != "") {
        FireStoreMethods()
            .dataUsernameUpdate(user.uid, _usernameController.text);
        isLoading = true;
        Fluttertoast.showToast(
          msg: "Bilgileriniz Güncellenmiştir.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffd94555),
          textColor: Colors.white,
          fontSize: 14,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Alanları Boş Bırakmayınız !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffd94555),
          textColor: Colors.white,
          fontSize: 14,
        );
      }

      setState(() {});
      _bioController.text = "";
      _usernameController.text = "";
      isLoading = false;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Kullanıcı Bilgileri',
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            TextFieldInput(
              textEditingController: _usernameController,
              hintText: 'Yeni Kullanıcı Adı Giriniz.',
              textInputType: TextInputType.text,
              icondata: const Icon(Icons.person),
            ),
            const SizedBox(height: 20),
            TextFieldInput(
              textEditingController: _bioController,
              hintText: 'Yeni Bio Giriniz.',
              textInputType: TextInputType.text,
              icondata: const Icon(Icons.info_sharp),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: changeBioUsername,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  color: Color(0xffd94555),
                ),
                child: isLoading == false
                    ? Text(
                        'Bilgileri Güncelle',
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      )
                    : const SpinKitCircle(
                        color: Colors.green,
                      ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
