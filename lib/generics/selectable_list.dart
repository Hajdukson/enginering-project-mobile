import 'package:flutter/material.dart';
import 'package:money_manager_mobile/widgets/fab/action_button.dart';
import 'package:money_manager_mobile/widgets/fab/expandable_fab.dart';
import '../../models/selectable_item_.dart';
abstract class SelectableList<T> extends StatefulWidget {
  SelectableList({
    Key? key, 
    this.isPage = false,
    required List<T> data, 
    this.onBulkActions, 
    this.noBulkActions,
    this.noItemSelectedVoidCallBack, 
    this.scrollController}) : _data = data, super(key: key);

  final bool isPage;
  final ScrollController? scrollController;

  final List<ActionButton>? onBulkActions;
  final List<ActionButton>? noBulkActions;
  final Function(BuildContext, dynamic)? noItemSelectedVoidCallBack;

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
  final listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    searchableItems.addAll(widget.selectableItems);
    widget.scrollController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isPage) {
      bool isAnySelected = searchableItems.any((item) => item.isSelected);
      if(widget.noBulkActions == null || widget.onBulkActions == null) {
        throw Exception("'noBulkActions' and 'onBulkActions' arguments are required");
      }
      return Scaffold(
        body: listContent,
        floatingActionButton: isAnySelected ? ExpandableFab(
          key: bulkActionFabKey,
          icon: const Icon(Icons.bolt),
          distance: 80.0,
          children: [            
            ...widget.onBulkActions!
          ],
        ) : ExpandableFab(
              key: noBulkActionFabKey,
              icon: const Icon(Icons.menu),
              distance: 80.0, 
              children: [
              ...widget.noBulkActions!
              ]
            )
      );
    }
    return listContent;
  }

  Widget get listContent => 
    Column(
      children: [
        widget.buildFilter(context, setFilterState),
        const SizedBox(
          height: 25,
        ),
        searchableItems.isNotEmpty ? Expanded(
          child: AnimatedList(
            key: listKey,
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
                  else if(widget.noItemSelectedVoidCallBack != null) {
                    widget.noItemSelectedVoidCallBack!(context, searchableItems[index].data);
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
        ) : Column(
          children: [
            const SizedBox(
              width: 140,
              child: Text("Nie znaloziono produktów", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            ),
            const SizedBox(height: 20,),
            Image.asset('assets/images/no_items.png'),
          ],)
    ]);

  /// Scrolls to the top of the list and animate insert [item]
  void animateInsert(SelectableItem<T> item) async {
      await widget.scrollController!.animateTo(0.0, duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
      searchableItems.insert(0, item);
      listKey.currentState!.insertItem(0, duration: const Duration(milliseconds: 500));
  }

  /// Removes selected items animation [animateTile] - list tile to animate
  void animateAndRemoveSelected(Widget Function(SelectableItem<T>, Animation<double>) animateTile) {
    var selectedItems = searchableItems.where((item) => item.isSelected).toList();
    var keys = selectedItems.map((e) => e.keyHelper);

    widget.selectableItems.removeWhere((item) => keys.any((key) => item.keyHelper == key));

    for(int i = 0; i < selectedItems.length; i++) {
      var item = searchableItems.firstWhere((item) => item.isSelected);
      listKey.currentState!.removeItem(searchableItems.indexOf(item), ((context, animation) => animateTile(item, animation)));
      searchableItems.remove(item);
    }
  }

  void setFilterState(List<SelectableItem<T>> selectableItems) {
    searchableItems = selectableItems; 
    setState(() { });
  }
}