import 'package:flutter/material.dart';

import 'models/selectable_item_.dart';

abstract class SelectableList<T> extends StatefulWidget {
  SelectableList({Key? key, required List<T> data}) : _data = data, super(key: key);

  final List<T> _data;
  late final List<SelectableItem<T>> selectableItems = _data.map((item) => SelectableItem(item)).toList();

  @override
  State<SelectableList> createState() => _SelectableListState();

  Widget buildChildren(int index);
}

class _SelectableListState extends State<SelectableList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.selectableItems.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if(widget.selectableItems[index].isSelected) {
              widget.selectableItems[index].isSelected = false;
            }
            else if(widget.selectableItems.any((item) => item.isSelected)){
              widget.selectableItems[index].isSelected = true;
            }
            setState(() { });
          },
          onLongPress: () {
            widget.selectableItems[index].isSelected = true;
            setState(() { });
          },
          child: widget.buildChildren(index),
        );
      });
  }
}