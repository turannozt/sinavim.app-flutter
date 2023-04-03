import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Icon icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: const Color(0xffd94555),
      leading: icon,
      subtitle: Text(
        subtitle,
        style: GoogleFonts.openSans(),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_outlined,
        size: 27,
      ),
      title: Text(
        title,
        style: GoogleFonts.openSans(fontWeight: FontWeight.w500),
      ),
      onTap: press,
    );
  }
}
