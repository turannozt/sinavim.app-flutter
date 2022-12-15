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

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _oncekiPassword = TextEditingController();
  bool isLoading = false;
  RewardedAd? _rewardedAd;

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _oncekiPassword.dispose();
  }

  @override
  void initState() {
    super.initState();

    _createRewardedAd();
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

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    void changePassword() {
      if (_passwordController.text != "" &&
          _oncekiPassword.text == user.password) {
        FireStoreMethods().dataPasswordUpdate(
            user.email, user.password, _passwordController.text, user.uid);
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
      } else if (_passwordController.text == "" || _oncekiPassword.text == "") {
        Fluttertoast.showToast(
          msg: "Şifre Alanını Boş Bırakmayınız.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffd94555),
          textColor: Colors.white,
          fontSize: 14,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Eski Şifreniz Uyuşmuyor",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffd94555),
          textColor: Colors.white,
          fontSize: 14,
        );
        setState(() {
          _oncekiPassword.text = "";
          _passwordController.text = "";
        });
      }
      setState(() {
        _oncekiPassword.text = "";
        _passwordController.text = "";
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Şifre',
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
              textEditingController: _oncekiPassword,
              hintText: 'Önceki Şifrenizi Giriniz',
              textInputType: TextInputType.text,
              isPass: true,
              icondata: const Icon(Icons.repeat),
            ),
            const SizedBox(height: 20),
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: 'Yeni Şifre Giriniz.',
              textInputType: TextInputType.text,
              isPass: true,
              icondata: const Icon(Icons.password_outlined),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: changePassword,
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
