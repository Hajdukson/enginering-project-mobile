import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/generics/models/selectable_item_.dart';

import '../../generics/selectable_list.dart';
import 'bought_product_tail.dart';
import 'fab/action_button.dart';
class ReciptList extends SelectableList<BoughtProduct> {
  ReciptList({
    Key? key, 
    ScrollController? scrollController,
    required List<BoughtProduct> recipt, 
    required this.edit,
    required GlobalKey<AnimatedListState> listKey,
    Icon isAnySelected = const Icon(Icons.delete_forever), 
    Icon notSelected = const Icon(Icons.add),
    required List<ActionButton> bulkActions, 
    required List<ActionButton> noBulkActions}) : 
      super(
        scrollController: scrollController,
        listKey: listKey,
        key: key, 
        data: recipt,
        noBulkActions: noBulkActions,
        onBulkActions: bulkActions);

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
  
  @override
  Widget buildFilter(BuildContext context, Function setStateOverride) {
    return TextField(
      style: Theme.of(context).textTheme.labelSmall,
      onChanged: (value) {
        setStateOverride(_runFilter(value));
      },
      decoration: const InputDecoration(
        labelText: 'Wyszukaj produkt', 
        suffixIcon: Icon(Icons.search)),
    );
  }

  List<SelectableItem<BoughtProduct>> _runFilter(String enteredKeyword) {
    List<SelectableItem<BoughtProduct>> results = [];
    if (enteredKeyword.isEmpty) {
      results = selectableItems;
    } else {
      results = selectableItems
        .where((item) => item.data.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
        .toList();
    }
    return results;
  }
}