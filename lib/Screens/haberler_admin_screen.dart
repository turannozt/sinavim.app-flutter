import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HaberlerAdminPage extends StatefulWidget {
  const HaberlerAdminPage({Key? key}) : super(key: key);

  @override
  State<HaberlerAdminPage> createState() => _HaberlerAdminPageState();
}

class _HaberlerAdminPageState extends State<HaberlerAdminPage> {
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Color(0xffd94555),
      Colors.blue,
      Colors.yellow,
      Colors.green,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 24,
      wordSpacing: 1,
      letterSpacing: 1,
      fontFamily: 'Horizon',
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: SizedBox(
          width: 280.0,
          child: AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'BİLGİLENDİRME',
                textStyle: colorizeTextStyle,
                colors: colorizeColors,
              ),
            ],
            isRepeatingAnimation: true,
            onTap: () {
              debugPrint("Tap Event");
            },
          ),
        ),
        centerTitle: false,
      ),
      body: Container(),
    );
  }
}
