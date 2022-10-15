import 'package:flutter/material.dart';
import 'package:money_manager_mobile/widgets/menu/bottom_main_menu.dart';
import 'package:money_manager_mobile/widgets/menu/page_view_main_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentPageIndex = 0;
  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomBar(
            pageIndex: _currentPageIndex,
            pageController: pageController,
            onBottomMenuTapHandler: onBottomMenuTap, 
            onSwipeHandler: onPageSwiape,),
          body: PageViewMainMenu(
            pageController: pageController, 
            onSwipeHandler: onPageSwiape, 
            pages: children,)),
      ),
    );
  }

  void onBottomMenuTap(int index, PageController pageController) {
    pageController.animateToPage(index,
        duration: Duration(microseconds: 500), curve: Curves.easeIn);
  }

  void onPageSwiape(int index){
    _currentPageIndex = index;
    setState(() {});
  }

  List<Widget> get children => [
    Text("test"),
    Text("data"),
  ];
}
