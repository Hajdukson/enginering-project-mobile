import 'package:flutter/material.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/fab/expandable_fab.dart';
import '../../models/bought_product.dart';
import '../pages/widgets/fab/action_button.dart';
import 'models/selectable_item_.dart';
abstract class SelectableList extends StatefulWidget {
  SelectableList({Key? key, required List<BoughtProduct> data, required this.listKey, required this.onBulkActions, required this.noBulkActions}) : _data = data, super(key: key);

  final GlobalKey<AnimatedListState> listKey;

  final List<ActionButton> onBulkActions;
  final List<ActionButton> noBulkActions;

  final List<BoughtProduct> _data;
  late final List<SelectableItem<BoughtProduct>> selectableItems = _data.map((item) => SelectableItem(item)).toList();

  @override
  State<SelectableList> createState() => SelectableListState();

  Widget buildChildren(SelectableItem<BoughtProduct> product, Animation<double> animation);
}

class SelectableListState extends State<SelectableList> {
  List<SelectableItem<BoughtProduct>> searchableBoughtProducts = [];

  final bulkActionFabKey = GlobalKey<ExpandableFabState>();
  final noBulkActionFabKey = GlobalKey<ExpandableFabState>();

  @override
  void initState() {
    searchableBoughtProducts.addAll(widget.selectableItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isAnySelected = searchableBoughtProducts.any((item) => item.isSelected);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(
                  labelText: 'Search', 
                  suffixIcon: Icon(Icons.search)),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: AnimatedList(
                  key: widget.listKey,
                  initialItemCount : searchableBoughtProducts.length,
                  itemBuilder: (context, index, animation) {
                    return GestureDetector(
                      onTap: () {
                        if(searchableBoughtProducts[index].isSelected) {
                          searchableBoughtProducts[index].isSelected = false;
                        }
                        else if(searchableBoughtProducts.any((item) => item.isSelected)){
                          searchableBoughtProducts[index].isSelected = true;
                        }
                        setState(() { });
                      },
                      onLongPress: () {
                        searchableBoughtProducts[index].isSelected = true;
                        setState(() { });
                      },
                      child: index > searchableBoughtProducts.length - 1 ? 
                        Container() : widget.buildChildren(searchableBoughtProducts[index], animation),
                    );
                  }),
              ),
            ]
          ),
        ),
      ),
      floatingActionButton: isAnySelected ? ExpandableFab(
        key: bulkActionFabKey,
        icon: const Icon(Icons.bolt),
        distance: 112.0,
        children: [
          ...widget.onBulkActions
        ],
      ) : ExpandableFab(
            key: noBulkActionFabKey,
            icon: const Icon(Icons.menu),
            distance: 112.0, 
            children: [
            ...widget.noBulkActions
            ]
          )
    );
  }

  void _runFilter(String enteredKeyword) {
    // TODO - można dodać tą samą animacje co przy usuwaniu wiele elementów (troche dziwne to będzie - taki dodatkowy quest)
    List<SelectableItem<BoughtProduct>> results = [];
    if (enteredKeyword.isEmpty) {
      results = widget.selectableItems;
    } else {
      results = widget.selectableItems
        .where((item) => item.data.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
        .toList();
    }
    searchableBoughtProducts = results;
    setState(() { });
  }
}