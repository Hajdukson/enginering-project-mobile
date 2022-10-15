import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int pageIndex;
  final PageController pageController;
  final Function(int, PageController) onBottomMenuTapHandler;
  final Function(int) onSwipeHandler;

  const BottomBar({
    Key? key,
    required this.pageIndex, 
    required this.pageController, 
    required this.onSwipeHandler, 
    required this.onBottomMenuTapHandler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
          currentIndex: pageIndex,
          onTap: (index) => {
                onBottomMenuTapHandler(index, pageController)
              },
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
            BottomNavigationBarItem(icon: Icon(Icons.camera_enhance_outlined), label: "Take a photo"),
          ]);
  }
}
