// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/generics/selectable_list.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/bought_product_tail.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/fab/action_button.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/recipt_list.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/yesno_dialog.dart';

class ReceiptView extends StatefulWidget {
  ReceiptView({Key? key, required this.recipt, }) : super(key: key);

  List<BoughtProduct> recipt;

  @override
  State<ReceiptView> createState() => ReceiptViewState();
}

class ReceiptViewState extends State<ReceiptView> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final reciptKey = GlobalKey<SelectableListState>();
  var listKey = GlobalKey<AnimatedListState>();

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
      onPressed: saveItemsDialog,
    ),
    ActionButton(
      icon: Icon(Icons.add),
      onPressed: addItem,
    ),
    ActionButton(
      icon: Icon(Icons.clear_all),
      onPressed: abortActionDialog,
    ),
  ];

  List<ActionButton> get noBulkActions => [
    ActionButton(
      icon: Icon(Icons.delete),
      onPressed: deleteSelectedItemsDialog,
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

  void deleteSelectedItems() {
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
    widget.recipt
      .addAll(reciptKey.currentState!.widget.selectableItems
      .map((item) => BoughtProduct(name: item.data.name, price: item.data.price)));

    setState(() {  });
  }

  void aboirtAction() {
    for(var i = 0; i < reciptKey.currentState!.widget.selectableItems.length; i++) {
      listKey.currentState!.removeItem(0, (context, animation) => Container());
    }
    widget.recipt.clear();
    setState(() { });
  }

  void saveItems() {
    BoughtProductsApi.postProducts(reciptKey.currentState!.widget.selectableItems
      .map((e) => BoughtProduct(id: 0, name: e.data.name, price: e.data.price, boughtDate: e.data.boughtDate)).toList());
    widget.recipt.clear();
    setState(() { });
  }

  void deleteSelectedItemsDialog() {
    showDialog(context: context, builder: ((context) => 
      YesNoDialog(
        title: "Abort data",
        description: "Are your sure you want to delete ${reciptKey.currentState!.searchableBoughtProducts.where((element) => element.isSelected).length} products?",
        onYesClickAction: () {
          deleteSelectedItems();
          Navigator.of(context).pop();
        },
        onNoClickAction: () {
          Navigator.of(context).pop();
        },
      )));
  }

  void abortActionDialog() {
    showDialog(context: context, builder: ((context) => 
      YesNoDialog(
        title: "Abort data",
        description: "Are your sure?",
        onYesClickAction: () {
          aboirtAction();
          Navigator.of(context).pop();
        },
        onNoClickAction: () {
          Navigator.of(context).pop();
        },
      )));
  }

  void saveItemsDialog() {
    showDialog(context: context, builder: ((context) => 
      YesNoDialog(
        title: "Save data",
        description: "Are your sure?",
        onYesClickAction: () {
          saveItems();
          Navigator.of(context).pop();
        },
        onNoClickAction: () {
          Navigator.of(context).pop();
        },
      )));
  }

  void addItem() {
    showDialog(context: context, builder: (context) => 
      YesNoDialog(
        title: "Text(),"
      ));  
  }
}