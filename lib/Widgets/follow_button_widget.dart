import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowButtonCard extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  const FollowButtonCard(
      {super.key, required this.title, required this.onPressed});

  @override
  State<FollowButtonCard> createState() => _FollowButtonCardState();
}

class _FollowButtonCardState extends State<FollowButtonCard> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xffd94555),
        shadowColor: Colors.greenAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        minimumSize: const Size(200, 30),
      ),
      onPressed: widget.onPressed,
      child: Text(
        widget.title,
        style: GoogleFonts.openSans(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
