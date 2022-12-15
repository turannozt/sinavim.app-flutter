import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimationTextHeadFeed extends StatefulWidget {
  const AnimationTextHeadFeed({Key? key}) : super(key: key);
  @override
  State<AnimationTextHeadFeed> createState() => _AnimationTextHeadFeedState();
}

class _AnimationTextHeadFeedState extends State<AnimationTextHeadFeed> {
  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Color(0xffd94555),
      Colors.blue,
      Colors.yellow,
      Colors.green,
    ];
    const colorizeTextStyle = TextStyle(
      fontSize: 30,
      wordSpacing: 1,
      letterSpacing: 1,
      fontFamily: 'Horizon',
    );

    return SizedBox(
      width: 280.0,
      child: AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText(
            'SINAVIM',
            textStyle: colorizeTextStyle,
            colors: colorizeColors,
          ),
        ],
        isRepeatingAnimation: true,
        onTap: () {
          debugPrint("Tap Event");
        },
      ),
    );
  }
}
