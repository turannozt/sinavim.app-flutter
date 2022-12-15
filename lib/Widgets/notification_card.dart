// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationCard extends StatefulWidget {
  final snap;
  const NotificationCard({
    super.key,
    required this.snap,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    var paylasimZamani = widget.snap['DateTime'].toDate();
    var ekranYuklemeZamani = DateTime.now();

    var snOnce = ekranYuklemeZamani.difference(paylasimZamani).inSeconds;

    Widget zaman(int fark) {
      if (fark <= 60) {
        return Text('$fark sn önce');
      } else if (fark <= 3600) {
        return Text('${(fark / 60).floor()} d önce');
      } else if (fark <= 86400) {
        return Text('${(fark / 3600).floor()} s önce');
      } else {
        return Text('${(fark / 86400).floor()} g önce');
      }
    }

    return ListTile(
      iconColor: Colors.green,
      leading: const Icon(
        Icons.notifications_active,
        size: 23,
      ),
      subtitle: Text(
        widget.snap['notiIcerik'],
        style: GoogleFonts.openSans(),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_outlined,
        size: 23,
      ),
      title: Row(
        children: [
          Text(
            widget.snap['notiUsername'],
            style: GoogleFonts.openSans(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            width: 2,
          ),
          zaman(snOnce),
        ],
      ),
    );
  }
}
