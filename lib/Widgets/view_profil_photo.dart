import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class HeroWidget extends StatelessWidget {
  final String profImage;
  const HeroWidget({Key? key, required this.profImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          'Profil Resmi',
          style: Theme.of(context).textTheme.headline6,
        ),
        elevation: 1,
      ),
      body: Center(
        child: Hero(
          tag: 'profImage',
          child: PinchZoom(
            resetDuration: const Duration(milliseconds: 100),
            maxScale: 3,
            child: Image.network(
              profImage.toString(),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
