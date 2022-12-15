import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sinavim_app/Resources/firestore_methods.dart';
import 'package:sinavim_app/Widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
        elevation: 1,
        title: Text(
          'Bildirimler',
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                          "Bildirimleri silmek istediğinizden emin misiniz ?"),
                      content: Text(
                        "•Bütün bildirimleriniz kaybolacaktır onaylıyor musunuz ?",
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          wordSpacing: 1,
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text("Hayır"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          child: const Text("Evet"),
                          onPressed: () {
                            FireStoreMethods().deleteNoti(
                                FirebaseAuth.instance.currentUser!.uid);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Notifications')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('DateTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitCircle(
                color: Colors.green,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return RefreshIndicator(
                onRefresh: _handleRefresh,
                color: Colors.red,
                child: NotificationCard(
                
                  snap: snapshot.data!.docs[index].data(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
