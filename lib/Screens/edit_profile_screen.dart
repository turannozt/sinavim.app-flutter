// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, non_constant_identifier_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sinavim_app/Responsive/mobile_screen_layout.dart';
import 'package:sinavim_app/Widgets/follow_button_widget.dart';
import 'package:sinavim_app/Widgets/profile_card.dart';
import 'package:sinavim_app/Widgets/social_media_card.dart';
import 'package:sinavim_app/models/user.dart' as model;
import 'package:provider/provider.dart';
import 'package:sinavim_app/Resources/auth_methods.dart';
import 'package:sinavim_app/Resources/firestore_methods.dart';
import 'package:sinavim_app/Screens/login_screen.dart';
import 'package:sinavim_app/Screens/onboard/onboarding_page.dart';
import 'package:sinavim_app/Utils/utils.dart';
import 'package:sinavim_app/Widgets/change_password_card.dart';
import 'package:sinavim_app/Widgets/feedback_card.dart';
import 'package:sinavim_app/Widgets/sss.dart';
import 'package:sinavim_app/Widgets/username_bio_change_card.dart';
import 'package:sinavim_app/Widgets/view_profil_photo.dart';
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:sinavim_app/services/add_mob_service.dart';
import 'package:social_media_flutter/social_media_flutter.dart';

class EditProfil extends StatefulWidget {
  final String uid;
  const EditProfil({Key? key, required this.uid}) : super(key: key);

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  Uint8List? _image;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();

    //Reklamı Çağırdık
    _createIntersitialAd();
  }

  selectImage() async {
    Uint8List im = await pickImage(
      ImageSource.gallery,
    );
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

// Reklam Alanı ---------------------

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

// Reklam Alanı ---------------------

  void signOut() async {
    await AuthMethods().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
    Fluttertoast.showToast(
      msg: "Oturumunuz Kapatılıyor...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xffd94555),
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    void dataProfilePicUpdate() {
      if (_image != null) {
        FireStoreMethods().dataProfilePicUpdate(_image!, user.uid);
        Fluttertoast.showToast(
          msg: "Profil Resminiz Güncellenmiştir.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffd94555),
          textColor: Colors.white,
          fontSize: 14,
        );
        _showInterstatialAd();
      } else {
        Fluttertoast.showToast(
          msg: "Profil Resmi Seçiniz !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffd94555),
          textColor: Colors.white,
          fontSize: 14,
        );
      }
    }


    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Ayarlar',
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              ProfileUpdate(context, user),
              const SizedBox(height: 10),
              Text(
                user.username,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              user.uid == "OpcgCbxGIjZyHYt0MVn71c505E42"
                  ? FollowButtonCard(
                      title: 'Çıkış Yap',
                      onPressed: () async {
                        signOut();
                        Navigator.pop(context);
                      },
                    )
                  : user.uid == "OpcgCbxGIjZyHYt0MVn71c505E42"
                      ? Container()
                      : FollowButtonCard(
                          title: 'Kaydet',
                          onPressed: dataProfilePicUpdate,
                        ),
              user.uid == "OpcgCbxGIjZyHYt0MVn71c505E42"
                  ? Text(
                      "Misafir Hesabındasınız! Hesap Oluşturun",
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 1,
                      ),
                    )
                  : Container(),
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: AyarWidgetleri(),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SocialWidget(
                placeholderText: '/turannozt',
                iconData: SocialIconsFlutter.instagram,
                link: 'https://www.instagram.com/turannozt/',
                iconSize: 24,
                placeholderStyle:
                    const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SocialWidget(
                placeholderText: '/Turan ÖZTÜRK',
                iconData: SocialIconsFlutter.linkedin_box,
                link: 'https://www.linkedin.com/in/turan-öztürk-744bb3219/',
                iconSize: 24,
                placeholderStyle:
                    const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Stack ProfileUpdate(BuildContext context, model.User user) {
    return Stack(
      children: [
        _image != null
            ? CircleAvatar(
                radius: 64,
                backgroundImage: MemoryImage(_image!),
                backgroundColor: Colors.transparent,
              )
            : Center(
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HeroWidget(profImage: user.profImage),
                    ),
                  ),
                  child: Hero(
                    tag: 'profImage',
                    child: CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(user.profImage),
                    ),
                  ),
                ),
              ),
        user.uid == "OpcgCbxGIjZyHYt0MVn71c505E42"
            ? Container()
            : Positioned(
                bottom: -10,
                left: 220,
                child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(Icons.add_a_photo_sharp),
                ),
              ),
      ],
    );
  }
}

class AyarWidgetleri extends StatelessWidget {
  const AyarWidgetleri({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    void signOut() async {
      await AuthMethods().signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
      Fluttertoast.showToast(
        msg: "Oturumunuz Kapatılıyor...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xffd94555),
        textColor: Colors.white,
        fontSize: 14,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          user.uid == "OpcgCbxGIjZyHYt0MVn71c505E42"
              ? Container()
              : ProfileMenu(
                  title: 'Kullanıcı Bilgileri',
                  subtitle: 'Kullanıcı Adı & Bio Günceller.',
                  press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UsernameBioChange(),
                    ),
                  ),
                  icon: const Icon(Icons.person),
                ),
          const Divider(endIndent: 20, indent: 20, thickness: 2),
          user.uid == "OpcgCbxGIjZyHYt0MVn71c505E42"
              ? Container()
              : ProfileMenu(
                  title: 'Şifre',
                  subtitle: 'Şifrenizi Günceller.',
                  press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePassword(),
                    ),
                  ),
                  icon: const Icon(Icons.password),
                ),
          const Divider(endIndent: 20, indent: 20, thickness: 2),
          user.uid == "OpcgCbxGIjZyHYt0MVn71c505E42"
              ? Container()
              : ProfileMenu(
                  title: 'Geri Bildirim',
                  subtitle:
                      'Önerilerinizi ve Şikayetlerinizi Bildirebilirsiniz.',
                  press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedbackPage(),
                    ),
                  ),
                  icon: const Icon(Icons.feedback),
                ),
          const Divider(endIndent: 20, indent: 20, thickness: 2),
          ProfileMenu(
            title: 'Sıkça Sorulan Sorular',
            subtitle: 'Sıkça Sorulan Soruları Listeler.',
            press: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SSS(),
              ),
            ),
            icon: const Icon(Icons.info),
          ),
          const Divider(endIndent: 20, indent: 20, thickness: 2),
          ProfileMenu(
            title: 'Tanıtım Ekranı',
            subtitle: 'Tanıtım Sayfasını Açar',
            press: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OnboardingPage(
                  onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MobileScreenLayout(),
                      ),
                      (route) => false),
                ),
              ),
            ),
            icon: const Icon(Icons.screen_share_outlined),
          ),
          const Divider(endIndent: 20, indent: 20, thickness: 2),
          ProfileMenu(
            title: 'Bizi Takip Edin',
            subtitle: 'Sosyal Medya Hesaplarımızdan Takip Edebilirsiniz.',
            icon: const Icon(
              FontAwesomeIcons.solidIdCard,
            ),
            press: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SocialMediaCard(),
              ),
            ),
          ),
          const Divider(endIndent: 20, indent: 20, thickness: 2),
          ProfileMenu(
            title: 'Çıkış Yap',
            subtitle: 'Hesabınızdan Çıkış Yapar.',
            icon: const Icon(
              FontAwesomeIcons.signOut,
            ),
            press: () async {
              signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
