import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';

class NoProducts<T> extends StatelessWidget {
  NoProducts({Key? key, required this.items}) : super(key: key);
  List<SelectableItem<T>> items;

  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              SizedBox(
                width: 140,
                child: Text(items.isNotEmpty ? "Nie znaloziono produktów" : "Brak produktów", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
              ),
              const SizedBox(height: 20,),
              Image.asset('assets/images/no_items.png', scale: 1.2,),
            ],);
  }
}