// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class BuildPage extends StatelessWidget {
  String urlImage;
  String title;
  String subtitle;
  BuildPage({
    super.key,
    required this.urlImage,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Image.asset(
                urlImage,
                fit: BoxFit.contain,
                width: double.infinity,
                height: 250,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  letterSpacing: 1,
                  wordSpacing: 1,
                ),
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ],
    );
  }
}
