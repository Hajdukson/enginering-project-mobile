import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_mobile/flavor/flavor_config.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';
import 'package:money_manager_mobile/widgets/receipt_preview.dart';
import 'package:photo_view/photo_view.dart';

class BoughtProductTail extends StatefulWidget {
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
  State<BoughtProductTail> createState() => _BoughtProductTailState();
}

class _BoughtProductTailState extends State<BoughtProductTail> {
  @override
  Widget build(BuildContext context) {
    var textStyle = const TextStyle(
      color: Colors.blueGrey,);
    return SizeTransition(
      sizeFactor: widget.animation,
      child: AnimatedContainer(
        margin: const EdgeInsets.all(6),
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: widget.product.isSelected ? Colors.lightGreen : null,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: widget.product.isSelected ? Border.all(color: Colors.black12, width: 2) : Border.all(color: Colors.grey),
        ),
        child: ListTile(
          leading: widget.product.data.imagePath == null ? 
            const Icon(Icons.shopping_bag_outlined, size: 40,) :
            IconButton(
              constraints: const BoxConstraints(),
              iconSize: 40,
              icon: const Icon(Icons.receipt),
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReceiptPreview(imageUrl: "${FlavorConfig.instance.values.baseUrl}/${widget.product.data.imagePath!}" ))
                  );
              }),
          title: Text("${widget.product.data.name}"),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
            child: Row(
              children: [
                Text("${widget.product.data.price?.toStringAsFixed(2)} PLN", style: widget.product.isSelected ? null : textStyle,),
                const SizedBox(width: 10,),
                widget.showDate ? Text(DateFormat("yMMMd", "pl").format(widget.product.data.boughtDate!), style: widget.product.isSelected ? null : textStyle,) : Container(),
              ],
            ),
          ),
          trailing: widget.trailingButton
        ),
      ),
    );
  }
}