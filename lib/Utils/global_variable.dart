import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sinavim_app/Screens/feed_screen.dart';
import 'package:sinavim_app/Screens/mentor_screen.dart';
import 'package:sinavim_app/Screens/profile_screen.dart';
import 'package:sinavim_app/Education%20Screens/questions_screen.dart';

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const QuestionsScreen(),
  // const HaberlerAdminPage(),
  const MentorScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

final List<String> items = [
  'Motivasyon',
  'Hedefim',
  'Kitap Okuyorum',
  'Geleceğe Notum',
  'Hayallerim',
  'Bugün Ne Çalıştım',
  'Ders Notu',
  'Soru',
  'Rekor Bende',
  'Ne Kadar Çalıştım'
];

final List<String> questionItems = [
  'Matematik',
  'Türkçe/Dil Bilgisi',
  'İngilizce',
  'F-K-B',
  'Sosyal',
];
