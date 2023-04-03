import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sinavim_app/Screens/edit_profile_screen.dart';
import 'package:sinavim_app/Screens/notifications_screen.dart';
import 'package:sinavim_app/Screens/search_screen.dart';
import 'package:sinavim_app/Widgets/saved_posts_card.dart';
import 'package:sinavim_app/providers/user_provider.dart';
import 'package:sinavim_app/models/user.dart' as model;

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    const padding = EdgeInsets.symmetric(horizontal: 10);
    return Drawer(
      child: Material(
        child: ListView(
          padding: padding,
          children: [
            const SizedBox(
              height: 40,
            ),
            buildHeaderItem(
              name: user.username,
              email: user.email,
              profImage: user.profImage.toString(),
            ),
            const SizedBox(
              height: 20,
            ),
            buildMenuItem(
              text: "Kullanıcı Ara",
              icon: Icons.people,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: "Kaydedilenler",
              icon: Icons.bookmark,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: "Güncellemeler",
              icon: Icons.update,
              onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.blueGrey),
            const SizedBox(height: 24),
            buildMenuItem(
              text: "Bildirimler",
              icon: Icons.notifications_outlined,
              onClicked: () => selectedItem(context, 3),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: "Ayarlar",
              icon: Icons.settings,
              onClicked: () => selectedItem(context, 4),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderItem({
    required String name,
    required String email,
    required String profImage,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(profImage),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                textAlign: TextAlign.left,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                textAlign: TextAlign.left,
                style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required VoidCallback? onClicked,
    required String text,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(
        icon,
      ),
      title: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    String? uid = FirebaseAuth.instance.currentUser!.uid;
    Navigator.of(context).pop(context);
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SearchScreen(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SavedPosts(
              uid: uid,
            ),
          ),
        );
        break;

      case 2:
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NotificationScreen(),
          ),
        );
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditProfil(
              uid: uid,
            ),
          ),
        );
        break;
      default:
    }
  }
}
