import 'package:flutter/cupertino.dart';

class PageViewMainMenu extends StatelessWidget {
  final PageController pageController;
  final Function(int)? onSwipeHandler;
  final List<Widget> pages;

  const PageViewMainMenu({
    Key? key,
    this.onSwipeHandler, 
    required this.pageController,
    required this.pages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      // onPageChanged: (pageIndex) {
      //   onSwipeHandler!(pageIndex);
      // },
      children: [...pages],
    );
  }
}