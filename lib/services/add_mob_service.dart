import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService {

  static String? get interstitialAdUnitedKullaniciGonderiSildiginde {
    //Kullanıcı Gönderi Sildiğinde
    return 'ca-app-pub-4921250076523363/4178889328';
  }

  static String? get rewardedAdUnitedIdKullaniciFotografliGonderiAttiginda {
    //Kullanıcı Fotoğraflı Gönderi Attığında
    return 'ca-app-pub-4921250076523363/2298847353';
  }

  static String? get rewardedAdUnitedIdKullaniciYaziliGonderiAttiginda {
    //Kullanıcı Yazılı Gönderi  Attığında
    return 'ca-app-pub-4921250076523363/1216564501';
  }
static String? get rewardedAdUnitedIdKullaniciSoruAttiginda {
    //Kullanıcı Soru Attığında
    return 'ca-app-pub-4921250076523363/6094606223';
  }
 
static String? get rewardedAdUnitedIdSoruSorEkraniDersler {
    //Soru Sor Ekranı Dersler
    return 'ca-app-pub-4921250076523363/1253343083';
  }
  static String? get rewardedAdUnitedIdOdulluSkor {
    //ROZET sistemi ödüllü reklam
    return 'ca-app-pub-4921250076523363/5527630017';
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad Loaded'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('Ad faild to load : $error');
    },
    onAdOpened: (ad) => debugPrint('Ad Opened'),
    onAdClosed: (ad) => debugPrint('Ad Closed'),
  );

  static BannerAd buildBannerAd(String bannerId) {
    return BannerAd(
      size: AdSize.fullBanner,
      adUnitId: bannerId,
      listener: AdmobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }



}
