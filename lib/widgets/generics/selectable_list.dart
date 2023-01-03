import 'package:flutter/material.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/fab/expandable_fab.dart';
import '../pages/widgets/fab/action_button.dart';
import 'models/selectable_item_.dart';
abstract class SelectableList<T> extends StatefulWidget {
  SelectableList({
    Key? key, 
    required List<T> data, 
    required this.listKey, 
    required this.onBulkActions, 
    required this.noBulkActions, 
    this.scrollController}) : _data = data, super(key: key);

  final GlobalKey<AnimatedListState> listKey;
  final ScrollController? scrollController;

  final List<ActionButton> onBulkActions;
  final List<ActionButton> noBulkActions;

  final List<T> _data;
  late final List<SelectableItem<T>> selectableItems = _data.map((item) => SelectableItem(item)).toList();

  @override
  State<SelectableList> createState() => SelectableListState();

  Widget buildChildren(SelectableItem<T> product, Animation<double> animation);

  Widget buildFilter(BuildContext context, Function (List<SelectableItem<T>>) setStateOverride);
}

class SelectableListState<T> extends State<SelectableList<T>> {
  List<SelectableItem<T>> searchableItems = [];

  final bulkActionFabKey = GlobalKey<ExpandableFabState>();
  final noBulkActionFabKey = GlobalKey<ExpandableFabState>();

  @override
  void initState() {
    searchableItems.addAll(widget.selectableItems);
    widget.scrollController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isAnySelected = searchableItems.any((item) => item.isSelected);
    return Scaffold(
      body: Column(
        children: [
          widget.buildFilter(context, setFilterState),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: AnimatedList(
              key: widget.listKey,
              controller: widget.scrollController,
              initialItemCount : searchableItems.length,
              itemBuilder: (context, index, animation) {
                return GestureDetector(
                  onTap: () {
                    if(searchableItems[index].isSelected) {
                      searchableItems[index].isSelected = false;
                    }
                    else if(searchableItems.any((item) => item.isSelected)){
                      searchableItems[index].isSelected = true;
                    }
                    setState(() { });
                  },
                  onLongPress: () {
                  if(searchableItems[index].isSelected) {
                    searchableItems[index].isSelected = false;
                  }
                  else {
                    searchableItems[index].isSelected = true;
                  }
                    setState(() { });
                  },
                  child: index > searchableItems.length - 1 ? 
                  Container() : widget.buildChildren(searchableItems[index], animation),
                );
              }),
          ),
        ]
      ),
      floatingActionButton: isAnySelected ? ExpandableFab(
        key: bulkActionFabKey,
        icon: const Icon(Icons.bolt),
        distance: 80.0,
        children: [
          ...widget.onBulkActions
        ],
      ) : ExpandableFab(
            key: noBulkActionFabKey,
            icon: const Icon(Icons.menu),
            distance: 80.0, 
            children: [
            ...widget.noBulkActions
            ]
          )
    );
  }

  void setFilterState(List<SelectableItem<T>> selectableItems) {
    searchableItems = selectableItems; 
    setState(() { });
  }
}