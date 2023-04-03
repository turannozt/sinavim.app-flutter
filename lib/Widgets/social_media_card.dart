// ignore_for_file: deprecated_member_use, avoid_print, depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/social_media_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaCard extends StatefulWidget {
  const SocialMediaCard({super.key});
  @override
  State<SocialMediaCard> createState() => _SocialMediaCardState();
}

class _SocialMediaCardState extends State<SocialMediaCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
        title: Text(
          'Bizi Takip Edin',
          style: Theme.of(context).textTheme.headline5,
        ),
        elevation: 1,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialWidget(
                        placeholderText: 'turannozt (Kurucu)',
                        iconData: SocialIconsFlutter.instagram,
                        iconColor: Colors.pink,
                        link: 'https://www.instagram.com/turannozt/',
                        placeholderStyle:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      SocialWidget(
                        placeholderText: 'sinavim.app (Uygulama)',
                        iconData: SocialIconsFlutter.instagram,
                        link: 'https://www.instagram.com/sinavim.app/',
                        iconColor: Colors.purple,
                        placeholderStyle:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      SocialWidget(
                        placeholderText: 'Turan ÖZTÜRK',
                        iconData: SocialIconsFlutter.youtube,
                        iconColor: Colors.red,
                        link:
                            'https://www.youtube.com/channel/UCyj2bxFxNxoLweqYqwpYIIA',
                        placeholderStyle:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      SocialWidget(
                        placeholderText: 'Turan ÖZTÜRK',
                        iconData: SocialIconsFlutter.linkedin_box,
                        link:
                            'https://www.linkedin.com/in/turan-öztürk-744bb3219/',
                        iconColor: Colors.blueGrey,
                        placeholderStyle:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      SocialWidget(
                        placeholderText: 'Turannn#9849',
                        iconData: SocialIconsFlutter.discord,
                        link: '',
                        iconColor: Colors.blueAccent,
                        placeholderStyle:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialWidget(
                    placeholderText: '/Turan ÖZTÜRK',
                    iconData: SocialIconsFlutter.youtube,
                    link:
                        'https://www.youtube.com/channel/UCyj2bxFxNxoLweqYqwpYIIA',
                    iconSize: 20,
                    placeholderStyle:
                        const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  SocialWidget(
                    placeholderText: '/Turan ÖZTÜRK',
                    iconData: SocialIconsFlutter.linkedin_box,
                    link: 'https://www.linkedin.com/in/turan-öztürk-744bb3219/',
                    iconSize: 20,
                    placeholderStyle:
                        const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          String email =
                              Uri.encodeComponent("sinavim.app@gmail.com");
                          String subject = Uri.encodeComponent(
                              "Mesajınızın konusunu giriniz.");
                          String body =
                              Uri.encodeComponent("Mesajınızı giriniz.");
                          print(subject); //output: Hello%20Flutter
                          Uri mail = Uri.parse(
                              "mailto:$email?subject=$subject&body=$body");
                          if (await launchUrl(mail)) {
                            //email app opened
                          } else {
                            //email app is not opened
                          }
                        },
                        icon: const Icon(
                          CupertinoIcons.mail,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      const Text(
                        'Mail (Uygulama)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          String email =
                              Uri.encodeComponent("turanozturk384@gmail.com");
                          String subject = Uri.encodeComponent(
                              "Mesajınızın konusunu giriniz.");
                          String body =
                              Uri.encodeComponent("Mesajınızı giriniz.");
                          print(subject); //output: Hello%20Flutter
                          Uri mail = Uri.parse(
                              "mailto:$email?subject=$subject&body=$body");
                          if (await launchUrl(mail)) {
                            //email app opened
                          } else {
                            //email app is not opened
                          }
                        },
                        icon: const Icon(
                          CupertinoIcons.mail,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Mail (Kurucu)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
