import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowUsersCard extends StatefulWidget {
  const ShowUsersCard({Key? key}) : super(key: key);

  @override
  State<ShowUsersCard> createState() => _ShowUsersCardState();
}

class _ShowUsersCardState extends State<ShowUsersCard> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  List usernameList = [];
  int index = 1;
  final double spacing = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(labelText: 'Kullanıcı Ara ...'),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              debugPrint(_);
            },
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where(
              'username',
              isGreaterThanOrEqualTo: searchController.text,
            )
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SpinKitCircle(
                color: Colors.green,
              ),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                    (snapshot.data! as dynamic).docs[index]['profImage'],
                  ),
                  radius: 16,
                ),
                trailing: GestureDetector(
                  onTap: () {
                    var gelenUserName =
                        (snapshot.data! as dynamic).docs[index]['username'];
                    usernameList.add(gelenUserName);
                    log("@${usernameList.toString()}");
                  },
                  child: Image.asset(
                    'assets/images/tags.png',
                    width: 22,
                  ),
                ),
                title: Text(
                  (snapshot.data! as dynamic).docs[index]['username'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
