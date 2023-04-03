import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Education%20Screens/Resources/firestore_methods.dart';
import 'package:sinavim_app/Utils/global_variable.dart';
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:sinavim_app/services/add_mob_service.dart';

class AddQuestionTextScreen extends StatefulWidget {
  const AddQuestionTextScreen({Key? key}) : super(key: key);
  @override
  State<AddQuestionTextScreen> createState() => _AddQuestionTextScreenState();
}

class _AddQuestionTextScreenState extends State<AddQuestionTextScreen> {
  RewardedAd? _rewardedAd;

  int _rewardedAdScore = 0;
  bool isLoading = false;
  String? selectedValue;
  final TextEditingController _descriptionController = TextEditingController();

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
      if (_descriptionController.text != "" &&
          _descriptionController.text.length > 3) {
        String res = await FireStoreQuestionMethods().uploadQuestinText(
          _descriptionController.text,
          uid,
          username,
          profImage,
          selectedValue.toString(),
          await token(),
        );
        if (res == "success") {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
            msg: "Soru Paylaşıldı !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xffd94555),
            textColor: Colors.white,
            fontSize: 14,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Metin Alanını Boş Bırakmayınız !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffd94555),
          textColor: Colors.white,
          fontSize: 14,
        );
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

//reklam alanı

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdmobService.rewardedAdUnitedIdKullaniciSoruAttiginda!,
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appbarTextPost(context, userProvider),
      // POST FORM
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? const LinearProgressIndicator()
                : const Padding(padding: EdgeInsets.only(top: 0.0)),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      userProvider.getUser.profImage,
                    ),
                    radius: 24,
                  ),
                ),
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.52,
                    child: TextField(
                      maxLength: 600,
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText:
                            "Sorunuzu Açıklayınız... (Doğru Cevabı'da Yazabilirisiniz !)",
                        border: InputBorder.none,
                      ),
                      maxLines: 5,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1),
            Row(
              children: [
                DropdownButtonHideUnderline(
                  child: etiketSec(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DropdownButton2<String> etiketSec() {
    return DropdownButton2(
      isExpanded: true,
      hint: Row(
        children: const [
          Icon(
            Icons.list,
            size: 16,
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: Text(
              'Ders Seç',
              style: TextStyle(
                fontSize: 14,
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

  AppBar appbarTextPost(BuildContext context, UserProvider userProvider) {
    return AppBar(
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Soru Oluştur',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: false,
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
    );
  }
}
