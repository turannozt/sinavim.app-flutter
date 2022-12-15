import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService {
  static String? get bannnerAdUnitedGonderiOlusturmaEkranlariAltinda {
    //Gönderi Oluşturma Ekranları Altında *
    return 'ca-app-pub-4921250076523363/9873090822';
  }

  static String? get inlineAdUnitedFeedScreenGonderileri {
    // Feed Screen & Mentor Screen 4 Gönderide Bir Reklam *
    return 'ca-app-pub-4921250076523363/3299981604';
  }

  static String? get interstitialAdUnitedKullaniciGonderiSildiginde {
    //Kullanıcı Gönderi Sildiğinde
    return 'ca-app-pub-4921250076523363/7246927480';
  }

  static String? get rewardedAdUnitedIdMentorGonderiAttiginda {
    //Mentör Gönderi Attığında
    return 'ca-app-pub-4921250076523363/9430275688';
  }

  static String? get rewardedAdUnitedIdKullaniciFotografliGonderiAttiginda {
    //Kullanıcı Fotoğraflı Gönderi Attığında
    return 'ca-app-pub-4921250076523363/5491030670';
  }

  static String? get rewardedAdUnitedIdKullaniciYaziliGonderiAttiginda {
    //Kullanıcı Yazılı Gönderi  Attığında
    return 'ca-app-pub-4921250076523363/4620764145';
  }

  static String? get inlineAdUnitedIdtags {
    //4 Gönderide Bir Tag Sayfası
    return 'ca-app-pub-4921250076523363/3104486588';
  }

  static String? get rewardedAdUnitedIdOdulluSkor {
    //ROZET sistemi ödüllü reklam
    return 'ca-app-pub-4921250076523363/7055355791';
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
}
