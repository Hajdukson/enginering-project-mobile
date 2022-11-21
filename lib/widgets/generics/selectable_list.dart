import 'package:flutter/material.dart';
import '../../models/bought_product.dart';
import 'models/selectable_item_.dart';
abstract class SelectableList extends StatefulWidget {
  SelectableList({Key? key, required List<BoughtProduct> data, required this.listKey, this.anySelectedIcon, this.notSelectedIcon , this.onAnySelectedHandler, this.onNotSelectedHandler}) : _data = data, super(key: key);

  final Icon? anySelectedIcon;
  final Icon? notSelectedIcon;
  final GlobalKey<AnimatedListState> listKey;

  final Function()? onAnySelectedHandler;
  final Function()? onNotSelectedHandler;

  final List<BoughtProduct> _data;
  late final List<SelectableItem<BoughtProduct>> selectableItems = _data.map((item) => SelectableItem(item)).toList();

  @override
  State<SelectableList> createState() => SelectableListState();

  Widget buildChildren(SelectableItem<BoughtProduct> product, Animation<double> animation);
}

class SelectableListState extends State<SelectableList> {
  List<SelectableItem<BoughtProduct>> searchableBoughtProducts = [];
  bool wasSearched = false;

  @override
  void initState() {
    searchableBoughtProducts.addAll(widget.selectableItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        floatingActionButton: _rednerFloatingButtons(),
    );
  }

  Widget _rednerFloatingButtons() {
    if(widget.anySelectedIcon != null && widget.notSelectedIcon != null) {
      return searchableBoughtProducts.any((item) => item.isSelected) ? 
          FloatingActionButton(onPressed: widget.onAnySelectedHandler, child: widget.anySelectedIcon) :
          FloatingActionButton(onPressed: widget.onNotSelectedHandler, child: widget.notSelectedIcon,);      
    } 
    else if(widget.anySelectedIcon == null && widget.notSelectedIcon == null) {
      return Container();
    }
    return FloatingActionButton(onPressed: widget.onAnySelectedHandler, child: widget.anySelectedIcon,);
  }

  void _runFilter(String enteredKeyword) {
    // TODO - można tu dodać tą samą animacje co przy usuwaniu wiele elementów (troche dziwne to będzie - taki dodatkowy quest)
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