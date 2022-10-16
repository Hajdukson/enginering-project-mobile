import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int pageIndex;
  final PageController pageController;
  final Function(int, PageController) onBottomMenuTapHandler;

  const BottomBar(
      {Key? key,
      required this.pageIndex,
      required this.pageController,
      required this.onBottomMenuTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.blue,
        currentIndex: pageIndex,
        onTap: (index) => {onBottomMenuTapHandler(index, pageController)},
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera), label: "Take a photo"),
        ]);
  }
}
