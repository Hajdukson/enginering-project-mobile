import 'package:flutter/material.dart';
import 'package:money_manager_mobile/generics/selectable_list.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';
import 'package:money_manager_mobile/widgets/bought_product_tile.dart';

class DetailsProductList extends SelectableList<BoughtProduct> {
  DetailsProductList({Key? key, required this.boughtProducts, required this.listKey}) : 
    super(
      key: key, 
      isPage: true,
      data: boughtProducts, 
      listKey: listKey,
      onBulkActions: [],
      noBulkActions: []);
  final List<BoughtProduct> boughtProducts;
  final GlobalKey<AnimatedListState> listKey;
  @override
  Widget buildChildren(SelectableItem<BoughtProduct> product, Animation<double> animation) {
    return BoughtProductTail(product: product, animation: animation, showDate: true,);
  }

  @override
  Widget buildFilter(BuildContext context, Function(List<SelectableItem<BoughtProduct>> p1) setStateOverride) {
    return Text("HAHAHHAHAHAH");
  }
}