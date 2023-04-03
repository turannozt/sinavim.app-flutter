// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Education%20Screens/Resources/firestore_methods.dart';
import 'package:sinavim_app/Utils/global_variable.dart';
import 'package:sinavim_app/Utils/utils.dart';
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:sinavim_app/services/add_mob_service.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({Key? key}) : super(key: key);

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  int _rewardedAdScore = 0;
  RewardedAd? _rewardedAd;
  Uint8List? _file;
  bool isLoading = false;
  String? selectedValue;
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            'Gönderi Oluştur',
            style: GoogleFonts.openSans(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Kameradan Çek',
                  style: GoogleFonts.openSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Galeriden Seç',
                  style: GoogleFonts.openSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: Text(
                "İptal",
                style: GoogleFonts.openSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _createRewardedAd();
  }

  Future<String> token() async {
    return await FirebaseMessaging.instance.getToken() ?? "";
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreQuestionMethods().uploadQuestin(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage,
          selectedValue.toString(),
          await token());
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Fluttertoast.showToast(
          msg: "Soru Paylaşıldı !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffd94555),
          textColor: Colors.white,
          fontSize: 14,
        );
        clearImage();
      } else {}
    } catch (err) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

//reklam alanı

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId:
          AdmobService.rewardedAdUnitedIdKullaniciSoruAttiginda!,
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

//reklam alanı
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if (_file == null) {
      return Scaffold(
        appBar: AppBarPostsAcilis(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Soru Yükle',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Center(
              child: IconButton(
                icon: const Icon(
                  Icons.upload,
                ),
                onPressed: () => _selectImage(context),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBarPosts(context, userProvider),
        // POST FORM
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isLoading
                ? const LinearProgressIndicator()
                : const Padding(padding: EdgeInsets.only(top: 0.0)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    Text(
                      userProvider.getUser.username,
                      style: GoogleFonts.openSans(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        userProvider.getUser.profImage,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60.0,
                  width: 60.0,
                  child: AspectRatio(
                    aspectRatio: 487 / 451,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                          image: MemoryImage(_file!),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: SizedBox(
                child: TextField(
                  maxLength: 600,
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText:
                        "Soru Açıklaması Giriniz... (Doğru Cevabı'da Yazabilirisiniz !)",
                    border: InputBorder.none,
                  ),
                  maxLines: 5,
                ),
              ),
            ),
            const Divider(),
            DropdownButtonHideUnderline(
              child: EtiketSec(),
            ),
          ],
        ),
      );
    }
  }

  DropdownButton2<String> EtiketSec() {
    return DropdownButton2(
      isExpanded: true,
      hint: Row(
        children: const [
          Icon(
            Icons.list,
            size: 20,
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: Text(
              'Ders Seç',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      items: questionItems
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      value: selectedValue,
      onChanged: (value) {
        setState(() {
          selectedValue = value as String;
        });
      },
      icon: const Icon(
        Icons.arrow_forward_ios_outlined,
        size: 18,
      ),
      iconSize: 14,
      buttonHeight: 50,
      buttonWidth: 160,
      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
      buttonDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      itemHeight: 40,
      itemPadding: const EdgeInsets.only(left: 14, right: 14),
      dropdownMaxHeight: 200,
      dropdownWidth: 200,
      dropdownPadding: null,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      dropdownElevation: 8,
      scrollbarRadius: const Radius.circular(40),
      scrollbarThickness: 6,
      scrollbarAlwaysShow: true,
    );
  }

  AppBar AppBarPosts(BuildContext context, UserProvider userProvider) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            icon: const Icon(Icons.send),
            onPressed: () {
              _descriptionController.text != ""
                  ? postImage(
                      userProvider.getUser.uid,
                      userProvider.getUser.username,
                      userProvider.getUser.profImage,
                    )
                  : Fluttertoast.showToast(
                      msg:
                          "Metin Alanını ve Ders Seç Alanını Boş Bırakmayınız!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color(0xffd94555),
                      textColor: Colors.white,
                      fontSize: 14,
                    );
              _descriptionController.text = "";
              _showRewardedAd();
            },
            label: Text(
              "Paylaş",
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
          ),
        )
      ],
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: clearImage,
      ),
      title: Text(
        'Soru Oluştur',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: false,
    );
  }

  AppBar AppBarPostsAcilis(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new),
      ),
      elevation: 1,
      title: Text(
        'Soru Sor',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: false,
    );
  }
}
