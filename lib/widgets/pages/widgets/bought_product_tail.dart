import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/generics/models/selectable_item_.dart';

class BoughtProductTail extends StatelessWidget {
  const BoughtProductTail({
    Key? key,
    required this.product, 
    required this.animation, 
    this.trailingButton}) : super(key: key);

  final SelectableItem<BoughtProduct> product;
  final Animation<double> animation;
  final IconButton? trailingButton;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 8,
        color: product.isSelected ? Colors.red : Colors.white,
        child: ListTile(
          title: Text("${product.data.name}"),
          subtitle: Text("${product.data.price}"),
          trailing: trailingButton
        ),
      ),
    );
  }
}


