import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sinavim_app/Education%20Screens/Widgets/question_card.dart';
import 'package:sinavim_app/Education%20Screens/Widgets/question_text_card.dart';
import 'package:sinavim_app/Widgets/feed_screen_appbar_title.dart';

class QuestionFeedPage extends StatefulWidget {
  const QuestionFeedPage({super.key});

  @override
  State<QuestionFeedPage> createState() => _QuestionFeedPageState();
}

class _QuestionFeedPageState extends State<QuestionFeedPage> {
  ScrollController scrollController = ScrollController();
  Future<void> _handleRefresh() async {
    return await Future.delayed(
      const Duration(seconds: 2),
      () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        elevation: 0,
        centerTitle: false,
        title: const AnimationTextHeadFeed(title: "Tüm Sorular"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Questions')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return snapshot.data!.docs[index].data()["postUrl"] != ""
                    ? QuestionCard(
                        snap: snapshot.data!.docs[index].data(),
                      )
                    : QuestionTextCard(
                        snap: snapshot.data!.docs[index].data(),
                      );
              },
            ),
          );
        },
      ),
    );
  }
}
