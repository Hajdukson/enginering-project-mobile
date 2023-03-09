import 'package:flutter/material.dart';

class BottomBarMainMenu extends StatelessWidget {
  final int pageIndex;
  final PageController pageController;
  final Function(int, PageController) onBottomMenuTapHandler;

  const BottomBarMainMenu(
      {Key? key,
      required this.pageIndex,
      required this.pageController,
      required this.onBottomMenuTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (index) => {onBottomMenuTapHandler(index, pageController)},
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person), label: "Twoje konto"),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt), label: "Dodaj paragon"),
        ]);
  }
}
