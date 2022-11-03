import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
class BoughtProductsPreview extends StatefulWidget {
  const BoughtProductsPreview({Key? key, required this.boughtProducts}) : super(key: key);
  final List<BoughtProduct> boughtProducts;

  @override
  State<BoughtProductsPreview> createState() => _BoughtProductsPreviewState();
}

class _BoughtProductsPreviewState extends State<BoughtProductsPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('The following products were found.')),
      body: ListView.builder(
        itemCount: widget.boughtProducts.length,
        itemBuilder: ((context, index) {
          return Card(child: ListTile(title: Text('${widget.boughtProducts[index].name} ${widget.boughtProducts[index].price} PLN')));
      })),
    );
  }
}