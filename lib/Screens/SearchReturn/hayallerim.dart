
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sinavim_app/Widgets/post_card.dart';
import 'package:sinavim_app/Widgets/post_text_card.dart';

class Hayallerim extends StatefulWidget {
  const Hayallerim({super.key});

  @override
  State<Hayallerim> createState() => _HayallerimState();
}

class _HayallerimState extends State<Hayallerim> {
 

  @override
  void initState() {
    super.initState();
    //Reklamı Çağırdık
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 1,
        title: Text(
          "Hayallerim",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('tag', isEqualTo: 'Hayallerim')
            .orderBy('datePublished', descending: true)
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
              return snapshot.data!.docs[index].data()["postUrl"] != ""
                  ? PostCard(
                      snap: snapshot.data!.docs[index].data(),
                    )
                  : PostCardText(
                      snap: snapshot.data!.docs[index].data(),
                    );
            },
          );
        },
      ),
    );
  }
}
