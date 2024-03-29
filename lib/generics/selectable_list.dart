import 'package:badges/badges.dart' as badge;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_mobile/widgets/fab/action_button.dart';
import 'package:money_manager_mobile/widgets/fab/expandable_fab.dart';
import 'package:money_manager_mobile/widgets/no_products.dart';
import '../../models/selectable_item_.dart';
abstract class SelectableList<T> extends StatefulWidget {
  SelectableList({
    Key? key, 
    this.isPage = false,
    required List<SelectableItem<T>> data, 
    this.onBulkActions, 
    this.noBulkActions,
    this.noItemSelectedVoidCallBack,}) : _data = data, super(key: key);

  final bool isPage;

  final List<ActionButton>? onBulkActions;
  final List<ActionButton>? noBulkActions;
  final Function(BuildContext, dynamic)? noItemSelectedVoidCallBack;

  final List<SelectableItem<T>> _data;
  late final List<SelectableItem<T>> selectableItems = _data;

  @override
  State<SelectableList> createState() => SelectableListState();

  Widget buildChildren(SelectableItem<T> product, Animation<double> animation);

  /// [setStateOverride] its a function that updates a state of item list 
  Widget buildFilter(BuildContext context, Function (List<SelectableItem<T>>) setStateOverride);
}

class SelectableListState<T> extends State<SelectableList<T>> {
  List<SelectableItem<T>> searchableItems = [];

  final scrollController = ScrollController();
  final bulkActionFabKey = GlobalKey<ExpandableFabState>();
  final noBulkActionFabKey = GlobalKey<ExpandableFabState>();
  final listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    searchableItems.addAll(widget.selectableItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isPage) {
      bool isAnySelected = searchableItems.any((item) => item.isSelected);
      if(widget.noBulkActions == null || widget.onBulkActions == null) {
        throw Exception("'noBulkActions' and 'onBulkActions' arguments are required");
      }
      return RefreshIndicator(
        onRefresh: () async {
          setState(() { });
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: listContent,
          floatingActionButton: isAnySelected ? ExpandableFab(
            heroTag: "bulk",
            key: bulkActionFabKey,
            icon: badge.Badge(
              position: BadgePosition.topEnd(top: -40),
              badgeContent: Text(searchableItems.where((item) => item.isSelected).length.toString()),
              child: const Icon(Icons.bolt)),
            distance: 80.0,
            children: [
              Tooltip(
                message: "Odznacz wszystko",
                child: ActionButton(
                  icon: const Icon(Icons.disabled_by_default), 
                  onPressed: unselectAll,),
              ),            
              ...widget.onBulkActions!
            ],
          ) : ExpandableFab(
                heroTag: "noBulk",
                key: noBulkActionFabKey,
                icon: const Icon(Icons.menu),
                distance: 80.0, 
                children: [
                ...widget.noBulkActions!
                ]
              )
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: listContent);
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
            controller: scrollController,
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
                child: index >= searchableItems.length ? 
                Container() : widget.buildChildren(searchableItems[index], animation),
              );
            }),
        ) : NoProducts(items: widget.selectableItems,)
         ]);
  
  void unselectAll() {
    for (var item in searchableItems) {
      item.isSelected = false;
    }
    setState(() { });
  }

  /// Scrolls to the top of the list and animate insert [item]
  Future animateInsert(SelectableItem<T> item) async {
    if(searchableItems.isNotEmpty) {
      await scrollController.animateTo(0.0, duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
    }
    searchableItems.insert(0, item);
    listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 500));
  }

  /// Removes selected items animation 
  /// [animateTile] - tile to animate
  void animateAndRemoveSelected(Widget Function(SelectableItem<T>, Animation<double>) animateTile) {
    var selectedItems = searchableItems.where((item) => item.isSelected).toList();
    var keys = selectedItems.map((e) => e.keyHelper).toList();

    for(int i = 0; i < selectedItems.length; i++) {
      var item = searchableItems.firstWhere((item) => item.isSelected);
      listKey.currentState!.removeItem(searchableItems.indexOf(item), ((context, animation) => animateTile(item, animation)));
      searchableItems.remove(item);
    }

    for (var key in keys) {
      widget.selectableItems.removeWhere((item) => item.keyHelper == key);
    }
    setState(() { });
  }

  /// Removes all items from [AnimatedList]
  void removeAllItems() {
    for(var i = 0; i < widget.selectableItems.length; i++) {
      listKey.currentState!.removeItem(0, (context, animation) => Container());
    }
    searchableItems.clear();
    setState(() { });
  }

  void setFilterState(List<SelectableItem<T>> selectableItems) {
    searchableItems = selectableItems; 
    setState(() { });
  }
}