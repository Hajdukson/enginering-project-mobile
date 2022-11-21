import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_mobile/flavor/flavor_values.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/menu/bottom_main_menu.dart';
import 'package:money_manager_mobile/widgets/menu/page_view_main_menu.dart';
import 'package:money_manager_mobile/widgets/pages/recipt_view.dart';
import 'package:money_manager_mobile/widgets/pages/camera_access.dart';

import 'flavor/flavor_config.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  FlavorConfig(
    values: FlavorValues(
      baseUrl: "https://192.168.1.31:7075"
    ));
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
        bottomNavigationBar: BottomBarMainMenu(
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
  var productList = [
        BoughtProduct(name: "kanapka", price: 10),
        BoughtProduct(name: "chleb", price: 10),
        BoughtProduct(name: "ciastka", price: 10),
        BoughtProduct(name: "kanapka", price: 10),
        BoughtProduct(name: "chleb", price: 10),
        BoughtProduct(name: "ciastka", price: 10),
        BoughtProduct(name: "biszkopt", price: 10),
        BoughtProduct(name: "biszkopt", price: 10),
        BoughtProduct(name: "ciastka", price: 10),
        BoughtProduct(name: "pizza", price: 10),
        BoughtProduct(name: "ciastka", price: 10),
        BoughtProduct(name: "frytki", price: 10),
        BoughtProduct(name: "ciastka", price: 10),
        BoughtProduct(name: "ciastka", price: 10),
      ];
  // for testing
  List<Widget> get children => [
    ReceiptView(recipt: productList,),
    CameraAccess(camera: widget.camera,),
  ];
}

 class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
