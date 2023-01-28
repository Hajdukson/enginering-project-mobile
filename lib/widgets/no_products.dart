import 'package:flutter/material.dart';

class NoProducts extends StatelessWidget {
  const NoProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              const SizedBox(
                width: 140,
                child: Text("Nie znaloziono produktów", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
              ),
              const SizedBox(height: 20,),
              Image.asset('assets/images/no_items.png', scale: 1.2,),
            ],);
  }
}