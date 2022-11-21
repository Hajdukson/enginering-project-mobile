import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/generics/models/selectable_item_.dart';

import '../../generics/selectable_list.dart';
import 'bought_product_tail.dart';
class ReciptList extends SelectableList {
  ReciptList({
    Key? key, 
    required List<BoughtProduct> recipt, 
    required this.edit,
    required GlobalKey<AnimatedListState> listKey,
    Icon isAnySelected = const Icon(Icons.delete_forever), 
    Icon notSelected = const Icon(Icons.add),
    required Function() onAnySelectedHandler,
    required Function() onNotSelectedHandler}) : 
      super(
        listKey: listKey,
        key: key, 
        data: recipt, 
        anySelectedIcon: isAnySelected,
        notSelectedIcon: notSelected,
        onAnySelectedHandler: onAnySelectedHandler,
        onNotSelectedHandler: onNotSelectedHandler);

  final void Function(BoughtProduct) edit;

  @override
  Widget buildChildren(SelectableItem<BoughtProduct> product, Animation<double> animation) {
    return BoughtProductTail(
      product: product,
      animation: animation,
      trailingButton: IconButton(
          onPressed: () {edit(product.data);},
          icon: const Icon(Icons.edit),),
    );
  }
}