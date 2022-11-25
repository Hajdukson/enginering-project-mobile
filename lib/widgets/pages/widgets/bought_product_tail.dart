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
      child: AnimatedContainer(
        margin: const EdgeInsets.all(6),
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: product.isSelected ? Colors.lightGreen : Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: product.isSelected ? Border.all(color: Colors.black12, width: 2) : null,
        ),
        child: ListTile(
          leading: const Icon(Icons.shopping_basket, size: 50,),
          title: Text("${product.data.name}"),
          subtitle: Text("${product.data.price} PLN"),
          trailing: trailingButton
        ),
      ),
    );
  }
}