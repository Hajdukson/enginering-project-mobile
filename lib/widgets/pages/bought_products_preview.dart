import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/bought_product.dart';

import '../generics/selectable_list.dart';
class BoughtProductsPreview extends SelectableList<BoughtProduct> {
  BoughtProductsPreview({Key? key, required List<BoughtProduct> boughtProducts}) : super(key: key, data: boughtProducts);
  
  @override
  Widget buildChildren(int index) {
    return Card(
      color: selectableItems[index].isSelected ? Colors.red : Colors.white,
      child: ListTile(
        title: Text("${selectableItems[index].data.name}"),
        subtitle: Text("${selectableItems[index].data.price}"),
        trailing: IconButton(
          onPressed: () {print("edit");},
          icon: const Icon(Icons.edit),),
      ),
    );
  }
}