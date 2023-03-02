// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/generics/selectable_list.dart';
import 'package:money_manager_mobile/menu/menu.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';
import 'package:money_manager_mobile/widgets/dialogs/two_input_dialog.dart';
import 'package:money_manager_mobile/widgets/dialogs/yesno_dialog.dart';
import 'package:money_manager_mobile/widgets/fab/action_button.dart';
import 'package:money_manager_mobile/widgets/lists/recipt_list.dart';
import 'package:money_manager_mobile/widgets/tiles/bought_product_tile.dart';

class ReceiptView extends StatefulWidget {
  ReceiptView({Key? key, required this.recipt, }) : super(key: key);

  List<BoughtProduct> recipt;

  @override
  State<ReceiptView> createState() => ReceiptViewState();
}

class ReceiptViewState extends State<ReceiptView> {
  final reciptKey = GlobalKey<SelectableListState>();
  var nameController = TextEditingController();
  var priceController = TextEditingController();

  DateTime? shoppingDate;

  @override
  void dispose() {
    super.dispose();
    reciptKey.currentState?.widget.selectableItems.clear();
  }

  @override
  void initState() {
    super.initState();
    if(widget.recipt.isNotEmpty) {
      shoppingDate = widget.recipt.first.boughtDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool result = false;
        showDialog(context: context, builder: ((context) => 
          YesNoDialog(
            description: "Jesteś pewien, że chcesz wrócić? Utracisz wszystkie dane.",
            onNoClickAction: () {
              result = false;
              Navigator.of(context).pop();
            },
            onYesClickAction: () {
              result = true;
              Navigator.of(context).pop();
              Navigator.of(context).pop(Menu());
            },
          )));
        return result;
      },
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(children: [
                const Text("Paragon z dnia", style: TextStyle(fontSize: 20),),
                TextButton(
                  onPressed: () async => await _selectDate(context), 
                  child: Text(widget.recipt.isNotEmpty && shoppingDate != null ? DateFormat('dd.MM.yyyy').format(shoppingDate!) : "- brak", style: TextStyle(fontSize: 20),))
              ],),
              Expanded(
                child: ReciptList(
                  noBulkActions: bulkActions,
                  bulkActions: noBulkActions,
                  key: reciptKey,
                  edit: (product) {
                    nameController = TextEditingController();
                    priceController = TextEditingController();
                    var itemToEdit = product;
                    var formKey = GlobalKey<FormState>();
                    nameController.text = itemToEdit.name.toString();
                    priceController.text = itemToEdit.price.toString();
                    showDialog(context: context, builder: (context) {
                      final firstInput = TextFormField(
                        decoration: InputDecoration(
                          label: Text("Nazwa"),
                        ),  
                        controller: nameController,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return "Pole nie może być puste";
                          }
                        },
                      );
                      final secondInput = TextFormField(
                        decoration: InputDecoration(
                          label: Text("Cena (PLN)")
                        ),
                        controller: priceController,
                        validator: (value) {
                          if(double.tryParse(value!) == null || value.isEmpty) {
                            return "Podaj cenę";
                          }
                        },
                      );
                      return TwoInputDialog(
                        formKey: formKey,
                        firstInput: firstInput,
                        secondInput: secondInput,
                        submitHandler: () {
                          edit(itemToEdit, formKey) ? () {
                            nameController.dispose();
                            priceController.dispose();
                          } : () {};
                        });});
                  },
                  recipt: widget.recipt
                ),
              )],
          ),
        ),
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
      onPressed: () {
        final nameController = TextEditingController();
        final priceController = TextEditingController();
        final formKey = GlobalKey<FormState>();

        showDialog(context: context, builder: (context) {
          final firstInput = TextFormField(
            decoration: InputDecoration(
              label: Text("Nazwa"),
            ),  
            controller: nameController,
            validator: (value) {
              if(value == null || value.isEmpty) {
                return "Pole nie może być puste";
              }
            },
          );
          final secondInput = TextFormField(
            decoration: InputDecoration(
              label: Text("Cena (PLN)")
            ),
            controller: priceController,
            validator: (value) {
              if(double.tryParse(value!) == null || value.isEmpty) {
                return "Podaj cenę";
              }
            },
          );
          return TwoInputDialog(
            formKey: formKey,
            firstInput: firstInput,
            secondInput: secondInput,
            submitHandler: () {
              addItem(nameController.text, priceController.text, formKey) ? () {
                nameController.dispose();
                priceController.dispose();
              } : (){};
            });});
        }),
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

  bool edit(BoughtProduct itemToEdit , GlobalKey<FormState> key) {
    if(key.currentState!.validate()) {
      itemToEdit.name = nameController.text;
      itemToEdit.price = double.tryParse(priceController.text);
      setState(() { });
      Navigator.of(context).pop();
      return true;
    }
    return false;
  }
  
  bool addItem(String name, String price, GlobalKey<FormState> key) {
    if(key.currentState!.validate()) {
      var boughtProduct = BoughtProduct(name: name, price: double.parse(price));
      widget.recipt.insert(0, boughtProduct);
      Navigator.of(context).pop();
      reciptKey.currentState!.animateInsert(SelectableItem<BoughtProduct>(boughtProduct));
      setState(() { });
      return true;
    }
    return false;
  }

  void deleteSelectedItems() {
    reciptKey.currentState!.animateAndRemoveSelected((item, animation) =>
          BoughtProductTail(product: item as SelectableItem<BoughtProduct>, animation: animation,));
    widget.recipt.clear();
    widget.recipt
      .addAll(reciptKey.currentState!.widget.selectableItems
        .map((item) => BoughtProduct(name: item.data.name, price: item.data.price)));

    setState(() {  });
  }

  void abortAction() {
    widget.recipt.clear();
    setState(() { });
    reciptKey.currentState!.removeAllItems();
    _navigateToMenu();
  }

  void saveItems() async {
    await BoughtProductsApi.postProducts(reciptKey.currentState!.widget.selectableItems
      .map((e) => BoughtProduct(id: 0, name: e.data.name, price: e.data.price, boughtDate: shoppingDate)).toList());
    widget.recipt.clear();
    reciptKey.currentState!.widget.selectableItems.clear();
    reciptKey.currentState!.searchableItems.clear();
    setState(() { });
    _navigateToMenu();
  }

  void deleteSelectedItemsDialog() {
    int selectedProducts = reciptKey.currentState!.searchableItems.where((element) => element.isSelected).length;
    showDialog(context: context, builder: ((context) => 
      YesNoDialog(
        title: "Usuń",
        description: "Jesteś pewny, że chcesz usunąć $selectedProducts ${selectedProducts == 1 ? "podukt" : selectedProducts >= 5 ? "produktów" : "produkty"}?",
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
        title: "Porzucenie danych",
        description: "Będziesz musiał ponownie zeskanować paragon",
        onYesClickAction: () {
          abortAction();
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
        title: "Zapisanie danych",
        description: "Czy chcesz zapisać dane?",
        onYesClickAction: () {
          Navigator.of(context).pop();
          saveItems();
        },
        onNoClickAction: () {
          Navigator.of(context).pop();
        },
      )));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale("pl", "PL"),
      initialDate: shoppingDate ?? DateTime.now(), 
      firstDate: DateTime(2015, 8), 
      lastDate: DateTime(2101, 8));
    if(picked != null) {
      shoppingDate = picked;
      setState(() { });
    }
  }

  void _navigateToMenu(){
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Menu()),
        (Route<dynamic> route) => false,
      );
    });
  }
}