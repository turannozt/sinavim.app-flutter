import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sinavim_app/Widgets/follow_button_widget.dart';
import 'package:sinavim_app/models/user.dart' as model;
import 'package:provider/provider.dart';
import 'package:sinavim_app/Screens/add_mentor_post_screen.dart';
import 'package:sinavim_app/Widgets/animation_text_kit.dart';
import 'package:sinavim_app/Widgets/mentor_post_card.dart';
import 'package:sinavim_app/providers/user_provider.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({Key? key}) : super(key: key);

  @override
  State<MentorScreen> createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  @override
  void initState() {
    super.initState();
  }

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
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: const AnimationTextHead(),
      ),
      body: user.engelkontrol == "false"
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('MentorPosts')
                  .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      color: Colors.green,
                    ),
                  );
                }
                return RefreshIndicator(
                  color: Colors.red,
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length + 1,
                    itemBuilder: (ctx, index) {
                      return MentorPostCard(
                        snap: snapshot.data!.docs[index].data(),
                      );
                    },
                  ),
                );
              },
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Oh no-amico.png',
                  width: double.infinity,
                  height: 300,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${user.username} Hesabınız Kurallara Uymadığınız Geçici Süreliğine Engellendi. Engel Sebebini Öğrenmek İçin İletişime Geçebilirsiniz.',
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      wordSpacing: 1,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                FollowButtonCard(
                  title: "İletişime Geç",
                  onPressed: () =>
                      Navigator.pushNamed(context, '/feedback-card'),
                ),
              ],
            ),
      floatingActionButton:
          user.uid == 'LFhBwQJng7Zn6BZLHVyvTIPAyvt1' || //Turan
                  user.uid == 'WlCcEFEEtuVsHLk6BW7iegxdHWY2' || //İrem
                  user.uid == "8qv0YXkXVnYjhudfCch3fx1VaGC2" || //Asuman
                  user.uid == "QBaTtUbO1Bc4Qd9CsX7k21R0fS13" || //Ayşegül
                  user.uid == "FXRLWXHsGbOeuhJmTxMnscuUFtv1" || //sınavım
                  user.uid == "bB0OYUKpuQhPw8BNOQWIhoiziE12" || //nimet
                  user.uid == "DXvNmVUyHigemLYRQtx5JZq4SCq2" // bilimsel cocuk
              ? FloatingActionButton(
                  backgroundColor: const Color(0xffd94555),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddMentorPost(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.post_add_outlined,
                    size: 27,
                    color: Colors.white,
                  ),
                )
              : Container(),
    );
  }
}
