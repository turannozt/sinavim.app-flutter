// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Screens/profile_screen.dart';
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:sinavim_app/models/user.dart' as model;

class Followers extends StatefulWidget {
  final String uid;
  final snap;
  const Followers({Key? key, required this.uid, this.snap}) : super(key: key);
  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  @override
  void initState() {
    super.initState();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getChargingHistory() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        elevation: 1,
        centerTitle: false,
        title: Text(
          'Takipçiler',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getChargingHistory(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            List list = data['followers'];
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          uid: data['followers'][index]['uid'],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          data['followers'][index]['uid'] == user.uid
                              ? user.profImage
                              : data['followers'][index]['profImage']),
                    ),
                    title: Text(data['followers'][index]['uid'] == user.uid
                        ? user.username
                        : data['followers'][index]['username']),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                  ),
                );
              },
            );
          }

          return const Center(
            child: SpinKitCircle(
              color: Colors.green,
            ),
          );
        },
      ),
    );
  }
}
