import 'package:flutter/material.dart';
import 'package:money_manager_mobile/flavor/flavor_config.dart';
import 'package:money_manager_mobile/widgets/menu/page_view_main_menu.dart';

import '../../models/bought_product.dart';
import '../pages/camera_access.dart';
import '../pages/recipt_view.dart';
import 'bottom_main_menu.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomBarMainMenu(
          pageIndex: _currentPageIndex,
          pageController: _pageController,
          onBottomMenuTapHandler: onBottomMenuTap,), 
        body: PageViewMainMenu(
          pageController: _pageController, 
          onSwipeHandler: onPageSwiape, 
          pages: children,));
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
    CameraAccess(camera: FlavorConfig.instance.values.camera,),
  ];
}