import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sinavim_app/Utils/colors.dart';
import 'package:sinavim_app/Utils/global_variable.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        //  physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.transparent,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_page == 0) ? Colors.pink : Colors.blueGrey,
            ),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.question_square_fill,
                color: (_page == 1) ? Colors.pink : Colors.blueGrey,
              ),
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.person_2_fill,
              color: (_page == 2) ? Colors.pink : Colors.blueGrey,
            ),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.person_solid,
              color: (_page == 3) ? Colors.pink : Colors.blueGrey,
            ),
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
