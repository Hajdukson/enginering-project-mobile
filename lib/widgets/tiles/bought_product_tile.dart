import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_mobile/flavor/flavor_config.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';
import 'package:photo_view/photo_view.dart';

class BoughtProductTail extends StatelessWidget {
  const BoughtProductTail({
    Key? key,
    required this.product, 
    required this.animation, 
    this.trailingButton,
    this.showDate = false}) : super(key: key);

  final bool showDate;
  final SelectableItem<BoughtProduct> product;
  final Animation<double> animation;
  final IconButton? trailingButton;

  @override
  Widget build(BuildContext context) {
    var textStyle = const TextStyle(
      color: Colors.blueGrey,);
    return SizeTransition(
      sizeFactor: animation,
      child: AnimatedContainer(
        margin: const EdgeInsets.all(6),
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: product.isSelected ? Colors.lightGreen : null,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: product.isSelected ? Border.all(color: Colors.black12, width: 2) : Border.all(color: Colors.grey),
        ),
        child: ListTile(
          leading: product.data.imagePath == null ? 
            const Icon(Icons.shopping_bag_outlined, size: 40,) :
            IconButton(
              constraints: const BoxConstraints(),
              iconSize: 40,
              icon: const Icon(Icons.receipt),
              padding: EdgeInsets.zero,
              onPressed: () => showDialog(
                context: context, 
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    children: [
                      PhotoView(
                        customSize: MediaQuery.of(context).size,
                        imageProvider: NetworkImage("${FlavorConfig.instance.values.baseUrl}/${product.data.imagePath!}",),
                        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(), 
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(5),
                              backgroundColor: MaterialStateProperty.all<Color>((Colors.blueGrey)),
                              shape:  MaterialStateProperty.all<CircleBorder>(const CircleBorder())
                              ),
                            child: const Icon(
                                Icons.close, 
                                color: Colors.black,
                                size: 40,),
                            ))),
                    ],
                  ),
                ))),
          title: Text("${product.data.name}"),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
            child: Row(
              children: [
                Text("${product.data.price?.toStringAsFixed(2)} PLN", style: product.isSelected ? null : textStyle,),
                const SizedBox(width: 10,),
                showDate ? Text(DateFormat("yMMMd", "pl").format(product.data.boughtDate!), style: product.isSelected ? null : textStyle,) : Container(),
              ],
            ),
          ),
          trailing: trailingButton
        ),
      ),
    );
  }
}