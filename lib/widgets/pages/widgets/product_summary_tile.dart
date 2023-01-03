import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/generics/models/selectable_item_.dart';

class ProductSummaryTile extends StatelessWidget {
  const ProductSummaryTile({
    required this.product,
    Key? key
    }) : super(key: key);

  final SelectableItem<BoughtProduct> product;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.all(10),
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        border:  Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    const Icon(Icons.sailing),
                    SizedBox(width: 15,),
                    Text("${product.data.name}"),
                  ],),
                Positioned(
                  right: 0,
                  child: AnimatedOpacity(
                      opacity: product.isSelected ? 1 : 0,
                      duration: Duration(milliseconds: 200),
                      child: Icon(Icons.check_circle, color: Colors.green, size: 25,),
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Divider(
                color: Colors.blueGrey,
                height: 1,
              ),
            ),
            SizedBox(height: 100,)
      
          ],
        ),
      ),
    );
  }

}