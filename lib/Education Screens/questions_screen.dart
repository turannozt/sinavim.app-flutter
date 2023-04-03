import 'package:flutter/material.dart';
import 'package:sinavim_app/Education%20Screens/home_screen.dart';
import 'package:sinavim_app/Widgets/feed_screen_appbar_title.dart';


class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const AnimationTextHeadFeed(title: "SORU SOR"),
      ),
      body: const HomeScreen(),
    );
  }
}
