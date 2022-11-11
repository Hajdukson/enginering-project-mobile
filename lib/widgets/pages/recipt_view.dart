import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/generics/models/selectable_item_.dart';
import 'package:money_manager_mobile/widgets/generics/selectable_list.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/recipt_list.dart';

class ReciptView extends StatefulWidget {
  ReciptView({Key? key, required this.recipt}) : super(key: key);

  List<BoughtProduct> recipt;

  @override
  State<ReciptView> createState() => ReciptViewState();
}

class ReciptViewState extends State<ReciptView> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final reciptKey = GlobalKey<SelectableListState>();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: ReciptList(
        onNotSelectedHandler: () {},
        onAnySelectedHandler: delete,
        key: reciptKey,
        edit: (product) {
          var itemToEdit = product;
          var formKey = GlobalKey<FormState>();
    
          nameController.text = itemToEdit.name.toString();
          priceController.text = itemToEdit.price.toString();
    
          showDialog(context: context, builder: (context) {
            return Dialog(
              child: Form(
                key: formKey,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 200,
                  child: Column(children: [
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return "Enter valid name.";
                        }
                      },
                    ),
                    TextFormField(
                      controller: priceController,
                      validator: (value) {
                        if(double.tryParse(value!) == null || value.isEmpty) {
                          return "Enter valid price.";
                        }
                      },
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(onPressed: () => edit(itemToEdit, formKey),  
                      child: const Text("Edit"))
                  ]),
                ),
                
              ),
            );
          });
        },
        recipt: widget.recipt
      ),
    );
  }

  void edit(BoughtProduct itemToEdit , GlobalKey<FormState> key) {
    if(key.currentState!.validate()) {
      itemToEdit.name = nameController.text;
      itemToEdit.price = double.tryParse(priceController.text);
      setState(() { });
      Navigator.of(context).pop();
    }
  }

  void delete() {
    var searchable = reciptKey.currentState?.searchableBoughtProducts.where((item) => item.isSelected).toList();
    reciptKey.currentState?.widget.selectableItems.removeWhere((it) => searchable!.any((element) => it.data.keyHelper == element.data.keyHelper));
    widget.recipt.removeWhere((it) => searchable!.any((element) => it.keyHelper == element.data.keyHelper));
    
    reciptKey.currentState?.searchableBoughtProducts.clear();
    reciptKey.currentState?.searchableBoughtProducts.addAll(widget.recipt.map((e) => SelectableItem(e)));

    setState(() { });
  }

  void add() {
    //TODO - napisać nowy endpoint w C#
  }
}