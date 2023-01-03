import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/generics/models/selectable_item_.dart';

class ProductSummaryTile extends StatelessWidget {
  const ProductSummaryTile({
    required this.productSummary,
    Key? key
    }) : super(key: key);

  final SelectableItem<ProductSummary> productSummary;

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
                    const SizedBox(width: 15,),
                    Text("${productSummary.data.productName}"),
                  ],),
                Positioned(
                  right: 0,
                  child: AnimatedOpacity(
                      opacity: productSummary.isSelected ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.check_circle, color: Colors.green, size: 25,),
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
            Row(children: [
              Column(
                children: [
                  Row(children: [Text("Data"), Text(" Cena")],),
                  Row(children: [],)
                ],
              ),
              Text("3,4"),
            ],)      
          ],
        ),
      ),
    );
  }

}

// Jakaś ikonka ---> Nazwa productu ---> jeżeli zaznacze ikonka V
// Divider
// Z dnia ----> Z dnia
// Cena   ----> Cena
// Inflacja