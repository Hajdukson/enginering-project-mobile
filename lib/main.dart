import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_mobile/widgets/menu/bottom_main_menu.dart';
import 'package:money_manager_mobile/widgets/menu/page_view_main_menu.dart';
import 'package:money_manager_mobile/widgets/pages/camera_access.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera,));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  Map<String, Object> pages = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomBar(
          pageIndex: _currentPageIndex,
          pageController: _pageController,
          onBottomMenuTapHandler: onBottomMenuTap,), 
        body: PageViewMainMenu(
          pageController: _pageController, 
          onSwipeHandler: onPageSwiape, 
          pages: children,)),
    );
  }

  void onBottomMenuTap(int index, PageController pageController) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void onPageSwiape(int index){
    _currentPageIndex = index;
    setState(() {});
  }

  List<Widget> get children => [
    SafeArea(child: Text("data")),
    CameraAccess(camera: widget.camera,),
  ];
}
