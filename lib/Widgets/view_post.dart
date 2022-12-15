import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class HeroWidgetPost extends StatelessWidget {
  final String postUrl;
  const HeroWidgetPost({Key? key, required this.postUrl}) : super(key: key);

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
          'Gönderi Resmi',
          style: Theme.of(context).textTheme.headline6,
        ),
        elevation: 1,
      ),
      body: Center(
        child: PinchZoom(
          resetDuration: const Duration(milliseconds: 100),
          maxScale: 3,
          child: Image.network(
            postUrl.toString(),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
