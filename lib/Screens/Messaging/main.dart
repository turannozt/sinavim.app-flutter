// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:sinavim_app/Screens/Messaging/constant.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const MaterialColor blue2 = MaterialColor(
    0xFF509A77,
    <int, Color>{
      50: Color(0xFFE1FCEF),
      100: Color(0xFFBCFDDF),
      200: Color(0xFF8EFAC7),
      300: Color(0xFF63F6B1),
      400: Color(0xFF42F5A0),
      500: Color(0xFF509A77),
      600: Color(0xFF1DE586),
      700: Color(0xFF18D079),
      800: Color(0xFF14BD6D),
      900: Color(0xFF0CA05A),
    },
  );

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  late TextEditingController _textToken;
  late TextEditingController _textSetToken;
  late TextEditingController _textTitle;
  late TextEditingController _textBody;

  @override
  void dispose() {
    _textToken.dispose();
    _textTitle.dispose();
    _textBody.dispose();
    _textSetToken.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    _textToken = TextEditingController();
    _textSetToken = TextEditingController();
    _textTitle = TextEditingController();
    _textBody = TextEditingController();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification!.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher'),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textToken,
                      decoration: const InputDecoration(
                          enabled: false,
                          labelText: "My Token for this Device"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _textToken.text));
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  _textToken.text = await token();
                
                },
                child: const Text('Get Token'),
              ),
              TextField(
                controller: _textTitle,
                decoration: const InputDecoration(labelText: "Enter Title"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _textBody,
                decoration: const InputDecoration(labelText: "Enter Body"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _textSetToken,
                decoration: const InputDecoration(labelText: "Enter Token"),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (_textSetToken.text.isNotEmpty && check()) {
                          pushNotificationsSpecificDevice(
                            title: _textTitle.text,
                            body: _textBody.text,
                            token: _textSetToken.text,
                          );
                        }
                      },
                      child:
                          const Text('Send Notification for specific Device'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (check()) {
                          pushNotificationsGroupDevice(
                            title: _textTitle.text,
                            body: _textBody.text,
                          );
                        }
                      },
                      child: const Text('Send Notification Group Device'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (check()) {
                          pushNotificationsAllUsers(
                            title: _textTitle.text,
                            body: _textBody.text,
                          );
                        }
                      },
                      child: const Text('Send Notification All Devices'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: showNotification,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 16,
          ),
          FloatingActionButton(
            onPressed: () async {
              if (check()) {
                pushNotificationsAllUsers(
                  title: _textTitle.text,
                  body: _textBody.text,
                );
              }
            },
            tooltip: 'Push Notifications',
            child: const Icon(Icons.send),
          )
        ],
      ),
    );
  }

  Future<bool> pushNotificationsSpecificDevice({
    required String token,
    required String title,
    required String body,
  }) async {
    String dataNotifications = '{ "to" : "$token",'
        ' "notification" : {'
        ' "title":"$title",'
        '"body":"$body"'
        ' }'
        ' }';

    await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    return true;
  }

  Future<bool> pushNotificationsGroupDevice({
    required String title,
    required String body,
  }) async {
    String dataNotifications = '{'
        '"operation": "create",'
        '"notification_key_name": "appUser-testUser",'
        '"registration_ids":["dV5pjB2aS_KAE1CuCrBPRG:APA91bHDjwDJbEBYVYtaBXdJ9hNHt2yNnoNhGU5k16AMvGcCFTAdK7h9GHWUu8rlthR8oQXbFJi5EBQQ1okFOZJC94m98manc6Or6CZr5TTDB-B8zzlMT1RrLzPakDg2kvM0Mir460bG","d1Kudv_ERRSY4ELxKjss-c:APA91bFMm-S56N35a6u8WAMiV88I3fNXKvhcLa8KbMrbjG7CdiVVCikJd3dyc0SgBkqlm3bsAJpU7rueX5esTYjOhILAUUNI8JXXZXDNXfWzi-wOWerYBfHFNR1JgL2N6c41iNJi8vaB"],'
        '"notification" : {'
        '"title":"$title",'
        '"body":"$body"'
        ' }'
        ' }';

    var response = await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
        'project_id': Constants.SENDER_ID
      },
      body: dataNotifications,
    );

    debugPrint(response.body.toString());

    return true;
  }

  Future<bool> pushNotificationsAllUsers({
    required String title,
    required String body,
  }) async {
    // FirebaseMessaging.instance.subscribeToTopic("myTopic1");

    String dataNotifications = '{ '
        ' "to" : "/topics/myTopic1" , '
        ' "notification" : {'
        ' "title":"$title" , '
        ' "body":"$body" '
        ' } '
        ' } ';

    var response = await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    debugPrint(response.body.toString());
    return true;
  }

  Future<String> token() async {
    return await FirebaseMessaging.instance.getToken() ?? "";
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  bool check() {
    if (_textTitle.text.isNotEmpty && _textBody.text.isNotEmpty) {
      return true;
    }
    return false;
  }
}
