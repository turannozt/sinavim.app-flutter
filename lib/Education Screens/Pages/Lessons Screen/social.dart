import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sinavim_app/Education%20Screens/Widgets/question_card.dart';
import 'package:sinavim_app/Education%20Screens/Widgets/question_text_card.dart';
import 'package:sinavim_app/Widgets/feed_screen_appbar_title.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
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
        title: const AnimationTextHeadFeed(title: "Tarih-Coğrafya-Felsefe"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Questions')
            .where('tag', isEqualTo: 'Sosyal')
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
