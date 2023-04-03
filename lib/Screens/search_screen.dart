import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Screens/profile_screen.dart';
import 'package:sinavim_app/Widgets/follow_button_widget.dart';
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:sinavim_app/models/user.dart' as model;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Kullanıcı Ara ...',
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              debugPrint(_);
            },
          ),
        ),
      ),
      body: user.engelkontrol == "false"
          ? isShowUsers
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where(
                        'username',
                        isGreaterThanOrEqualTo: searchController.text,
                      )
                      .snapshots(),
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
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uid: (snapshot.data! as dynamic).docs[index]
                                    ['uid'],
                              ),
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ['profImage'],
                              ),
                              radius: 16,
                            ),
                            title: Text(
                              (snapshot.data! as dynamic).docs[index]
                                  ['username'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 5.0,
                    children: [
                      _buildChip(
                        'Motivasyon',
                        Colors.red,
                        () => Navigator.pushNamed(
                          context,
                          '/motivasyon',
                        ),
                      ),
                      _buildChip(
                        'Hedefim',
                        Colors.green,
                        () => Navigator.pushNamed(
                          context,
                          '/hedefim',
                        ),
                      ),
                      _buildChip(
                        'Kitap Okuyorum',
                        Colors.pink,
                        () => Navigator.pushNamed(
                          context,
                          '/kitap-okuyorum',
                        ),
                      ),
                      _buildChip(
                        'Geleceğe Notum',
                        Colors.deepOrange,
                        () => Navigator.pushNamed(
                          context,
                          '/gelecege-notum',
                        ),
                      ),
                      _buildChip(
                        'Hayallerim',
                        Colors.purpleAccent,
                        () => Navigator.pushNamed(
                          context,
                          '/hayallerim',
                        ),
                      ),
                      _buildChip(
                        'Bugün Ne Çalıştım',
                        Colors.amber,
                        () => Navigator.pushNamed(
                          context,
                          '/bugun-ne-calistim',
                        ),
                      ),
                      _buildChip(
                        'Ders Notu',
                        Colors.red,
                        () => Navigator.pushNamed(
                          context,
                          '/ders-notu',
                        ),
                      ),
                      _buildChip(
                        'Sorular',
                        Colors.blue,
                        () => Navigator.pushNamed(
                          context,
                          '/sorular',
                        ),
                      ),
                      _buildChip(
                        'Rekor Bende',
                        Colors.grey,
                        () => Navigator.pushNamed(
                          context,
                          '/rekor-bende',
                        ),
                      ),
                      _buildChip(
                        'Ne Kadar Çalıştım',
                        Colors.pinkAccent,
                        () => Navigator.pushNamed(
                          context,
                          '/ne-kadar-calistim',
                        ),
                      ),
                    ],
                  ),
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
    );
  }

  Widget _buildChip(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        labelPadding: const EdgeInsets.all(2.0),
        avatar: CircleAvatar(
          backgroundColor: Colors.white70,
          child: Text(
            label[0].toUpperCase(),
          ),
        ),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: color,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: const EdgeInsets.all(8.0),
      ),
    );
  }
}
