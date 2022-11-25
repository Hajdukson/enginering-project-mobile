// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/generics/selectable_list.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/bought_product_tail.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/fab/action_button.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/recipt_list.dart';

class ReceiptView extends StatefulWidget {
  ReceiptView({Key? key, required this.recipt}) : super(key: key);

  List<BoughtProduct> recipt;

  @override
  State<ReceiptView> createState() => ReceiptViewState();
}

class ReceiptViewState extends State<ReceiptView> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final reciptKey = GlobalKey<SelectableListState>();
  final listKey = GlobalKey<AnimatedListState>();

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
        noBulkActions: bulkActions,
        bulkActions: noBulkActions,
        listKey: listKey,
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

  List<ActionButton> get bulkActions => [
    ActionButton(
      icon: Icon(Icons.save),
      onPressed: () {print("zapisanie produktow");},
    ),
    ActionButton(
      icon: Icon(Icons.add),
      onPressed: () {print("dodanie pojedynczego product");},
    ),
    ActionButton(
      icon: Icon(Icons.clear_all),
      onPressed: () {print("porzucenie akcji");},
    ),
  ];

  List<ActionButton> get noBulkActions => [
    ActionButton(
      icon: Icon(Icons.delete),
      onPressed: delete,
    ),
  ];

  void edit(BoughtProduct itemToEdit , GlobalKey<FormState> key) {
    if(key.currentState!.validate()) {
      itemToEdit.name = nameController.text;
      itemToEdit.price = double.tryParse(priceController.text);
      setState(() { });
      Navigator.of(context).pop();
    }
  }

  void delete() {
    var products = reciptKey.currentState!.searchableBoughtProducts;
    var selectedProducts = products.where((element) => element.isSelected).toList();
    var numberOfSelectedProducts = selectedProducts.length;

    for(var i = 0; i < numberOfSelectedProducts; i++) {
      var product = products.firstWhere((element) => element.isSelected);

      listKey.currentState!.removeItem(products.indexOf(product), (context, animation) 
        => BoughtProductTail(product: product, animation: animation,));
      
      products.remove(product);
    }
    reciptKey.currentState!.widget.selectableItems.removeWhere((item) => item.isSelected);
    widget.recipt.clear();
    widget.recipt.addAll(reciptKey.currentState!.widget.selectableItems.map((item) => BoughtProduct(name: item.data.name, price: item.data.price)));
    setState(() {  });
  }

  void add() {
    //TODO - napisać nowy endpoint w C#
  }
}