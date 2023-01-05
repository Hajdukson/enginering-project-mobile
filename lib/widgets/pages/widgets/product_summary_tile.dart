import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/generics/models/selectable_item_.dart';
import 'dart:math' as math;

class ProductSummaryTile extends StatelessWidget {
  const ProductSummaryTile({required this.productSummary, Key? key})
      : super(key: key);

  final SelectableItem<ProductSummary> productSummary;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.all(10),
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_bag_rounded),
                    const SizedBox(
                      width: 15,
                    ),
                    Text("${productSummary.data.productName}"),
                  ],
                ),
                Positioned(
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: productSummary.isSelected ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 25,
                    ),
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
            Stack(children: [
              Table(
                columnWidths: const {0 : FixedColumnWidth(150)},
                children: [
                  const TableRow(children: [
                    TableCell(child: Text("Data zakupu", style: TextStyle(fontWeight: FontWeight.bold),)),
                    TableCell(child: Text("Cena", style: TextStyle(fontWeight: FontWeight.bold))),
                  ]),
                  TableRow(
                    children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                            style: const TextStyle(color: Colors.blueGrey),
                            DateFormat('dd.MM.yyyy').format(productSummary.data.startProduct!.boughtDate!)),
                      )),
                    TableCell(
                      child:
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            style: const TextStyle(color: Colors.blueGrey),
                            "${productSummary.data.startProduct!.price} PLN",)))
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          style: const TextStyle(color: Colors.blueGrey),
                          DateFormat('dd.MM.yyyy').format(productSummary.data.endProduct!.boughtDate!)),
                        )),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          style: const TextStyle(color: Colors.blueGrey),
                          "${productSummary.data.endProduct!.price} PLN")))
                  ]),
                ],
              ),
              Positioned(
                top: 5,
                right: 30,
                child: Column(
                  children: [
                    Text("${productSummary.data.porductInflation! < 0 ? 
                      productSummary.data.porductInflation! * -1 : productSummary.data.porductInflation!} %", 
                      style: TextStyle(
                        fontSize: 24,
                        color: productSummary.data.porductInflation! > 0 ?Colors.red : Colors.green),),
                    Transform.rotate(
                      angle: productSummary.data.porductInflation!  > 0 ? 0.4 : -0.4,
                      child: Icon(
                        productSummary.data.porductInflation!  > 0 ? Icons.trending_up : Icons.trending_down, 
                        size: 30,
                        color: productSummary.data.porductInflation! > 0 ? Colors.red : Colors.green,))
                ])),
            ]),
          ],
        ),
      ),
    );
  }
}
// TODO - animacja strzłek
// trending_up
// trenidng_down