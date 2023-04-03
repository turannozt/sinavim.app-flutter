import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grock/grock.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Screens/Messaging/messaging.dart';
import 'package:sinavim_app/Screens/SearchReturn/sorular.dart';
import 'package:sinavim_app/Utils/colors.dart';
import 'package:sinavim_app/providers/user_provider.dart';
import 'Education Screens/Pages/Lessons Screen/english.dart';
import 'Education Screens/Pages/Lessons Screen/fkb.dart';
import 'Education Screens/Pages/Lessons Screen/math.dart';
import 'Education Screens/Pages/Lessons Screen/social.dart';
import 'Education Screens/Pages/Lessons Screen/turkish.dart';
import 'Education Screens/Pages/questions_feed_page.dart';
import 'Screens/SearchReturn/bugun_ne_calistim.dart';
import 'Screens/SearchReturn/ders_notu.dart';
import 'Screens/SearchReturn/gelecege_notum.dart';
import 'Screens/SearchReturn/hayallerim.dart';
import 'Screens/SearchReturn/hedefim.dart';
import 'Screens/SearchReturn/kitap_okuyorum.dart';
import 'Screens/SearchReturn/motivatio_screen.dart';
import 'Screens/SearchReturn/ne_kadar_calistim.dart';
import 'Screens/SearchReturn/rekor_bende.dart';
import 'Screens/login_screen.dart';
import 'Screens/onboard/onboarding_page.dart';
import 'Screens/verify_email_screen.dart';
import 'Widgets/all_users_card.dart';
import 'Widgets/feedback_card.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  RenderErrorBox.backgroundColor = Colors.transparent;
  ErrorWidget.builder = (FlutterErrorDetails details) => const Scaffold(
        body: Center(
          child: SpinKitCircle(
            color: Colors.green,
          ),
        ),
      );

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC9z1g3csl-Yb5OpiiixikUXpBoKVOhH8k",
          authDomain: "sinavim-b3be0.firebaseapp.com",
          projectId: "sinavim-b3be0",
          storageBucket: "sinavim-b3be0.appspot.com",
          messagingSenderId: "664632715729",
          appId: "1:664632715729:web:3aa7c4a1cf9413d917d8f0"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

ThemeData _lightTheme = ThemeData(
  backgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Color(0xff783838)),
    color: Colors.white,
    centerTitle: false,
    actionsIconTheme: IconThemeData(color: Color(0xffd94555), shadows: [
      BoxShadow(
          offset: Offset(0, 0),
          blurStyle: BlurStyle.outer,
          color: Colors.grey,
          spreadRadius: 5),
    ]),
  ),
  brightness: Brightness.light,
  iconTheme: const IconThemeData(color: Colors.black87),
  primaryColor: primaryColorLight,
  textTheme: const TextTheme(),
  scaffoldBackgroundColor: mobileBackgroundColorLight,
  buttonTheme: const ButtonThemeData(
    buttonColor: primaryColorLight,
    textTheme: ButtonTextTheme.primary,
  ),
);

ThemeData _darkTheme = ThemeData(
  bottomNavigationBarTheme:
      const BottomNavigationBarThemeData(backgroundColor: Colors.black87),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    color: Colors.black87,
    centerTitle: false,
    actionsIconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  bottomAppBarColor: Colors.black87,
  brightness: Brightness.dark,
  iconTheme: const IconThemeData(color: Colors.white),
  primaryColor: primaryColorLight,
  scaffoldBackgroundColor: Colors.black87,
  buttonTheme: const ButtonThemeData(
    buttonColor: blueColor,
    textTheme: ButtonTextTheme.primary,
  ),
);

bool _light = true;

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.initialize(flutterLocalNotificationsPlugin);
    initialization();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/sorular': (context) => const Sorular(),
          '/rekor-bende': (context) => const RekorBende(),
          '/ders-notu': (context) => const DersNotu(),
          '/gelecege-notum': (context) => const GelecegeNotum(),
          '/hayallerim': (context) => const Hayallerim(),
          '/hedefim': (context) => const Hedefim(),
          '/kitap-okuyorum': (context) => const KitapOkuyorum(),
          '/motivasyon': (context) => const Motivasyon(),
          '/bugun-ne-calistim': (context) => const BugunNeCalistim(),
          '/ne-kadar-calistim': (context) => const NeKadarCalistim(),
          '/all-users': (context) => const AllUsers(),
          '/feedback-card': (context) => const FeedbackPage(),
          '/math': (context) => const MathScreen(),
          '/turkish': (context) => const TurkishScreen(),
          '/social': (context) => const SocialScreen(),
          '/fkb': (context) => const FKBhScreen(),
          '/english': (context) => const EnglishScreen(),
          '/all-questions': (context) => const QuestionFeedPage(),
        },
        navigatorKey: Grock.navigationKey,
        scaffoldMessengerKey: Grock.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'SINAVIM',
        darkTheme: _darkTheme,
        theme: _light ? _lightTheme : _darkTheme,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const VerifyEmailPage();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitCircle(
                  color: Colors.green,
                ),
              );
            }
            return OnboardingPage(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
