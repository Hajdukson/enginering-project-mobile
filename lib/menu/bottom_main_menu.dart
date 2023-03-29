import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final texts = AppLocalizations.of(context)!;
    return BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (index) => {onBottomMenuTapHandler(index, pageController)},
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.person), label: texts.yoursAccount),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt), label: texts.addReceipt),
        ]);
  }
}
