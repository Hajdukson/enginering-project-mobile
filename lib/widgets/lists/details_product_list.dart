import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_mobile/generics/selectable_list.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';
import 'package:money_manager_mobile/widgets/tiles/bought_product_tile.dart';

class DetailsProductList extends SelectableList<BoughtProduct> {
  DetailsProductList({Key? key, required this.boughtProducts, required GlobalKey<AnimatedListState> listKey}) : 
    super(
      key: key, 
      isPage: true,
      data: boughtProducts, 
      listKey: listKey,
      onBulkActions: [],
      noBulkActions: []);

  final List<BoughtProduct> boughtProducts;
  
  @override
  Widget buildChildren(SelectableItem<BoughtProduct> product, Animation<double> animation) {
    return BoughtProductTail(product: product, animation: animation, showDate: true,);
  }

  @override
  Widget buildFilter(BuildContext context, Function(List<SelectableItem<BoughtProduct>> p1) setStateOverride) {
    final expandableControler = ExpandableController();

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton<String?>(
                initialValue: "",
                onSelected: (String? value) {
                  
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(value: "", child: Text("Cena najwyższ"),),
                    PopupMenuItem(value: "", child: Text("Cena najniższa"),),
                    PopupMenuItem(value: "", child: Text("Data rosnąco"),),
                    PopupMenuItem(value: "", child: Text("Data malejąco"),),
                  ];
                },
                child: const Text("Sortuj", style: TextStyle(fontSize: 20),),),
              TextButton(
                onPressed: () {
                  expandableControler.toggle();
                }, 
                child: Row(
                  children: const [
                    Icon(Icons.filter_alt, color: Colors.white,),
                    Text("Filtry", style: TextStyle(color: Colors.white, fontSize: 20),), 
                  ],
              ))
            ],
          ),
          ExpandableNotifier(
            controller: expandableControler,
            child: ExpandablePanel(
              controller: expandableControler,
              collapsed: Container(),
              expanded: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Cena"),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _showDateRange(context),
                          child: const Text("Zmień datę"),
                        ),
                        const SizedBox(width: 5,),
                        ElevatedButton(onPressed: () {}, child: const Icon(Icons.refresh))
                      ],
                    ),
                  ],
                ),
              ),
            ),
        )]),
      );
  }

  Future<DateTimeRange?> _showDateRange(BuildContext context) async {
    DateTimeRange? dateTimeRange = await showDateRangePicker(
      context: context, 
      locale: const Locale("pl", "PL"),
      firstDate: DateTime(2015, 8), 
      lastDate: DateTime(2101, 8));
    return dateTimeRange;
  }
}