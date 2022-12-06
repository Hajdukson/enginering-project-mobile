// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/generics/models/selectable_item_.dart';
import 'package:money_manager_mobile/widgets/generics/selectable_list.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/bought_product_tail.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/fab/action_button.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/recipt_list.dart';

import '../widgets/dialogs/two_input_dialog.dart';
import '../widgets/dialogs/yesno_dialog.dart';

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
  final listKey = GlobalKey<AnimatedListState>();

  late final scrollController = ScrollController();

  late DateTime shoppingDate;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
  }

  @override
  void initState() {
    super.initState();
    shoppingDate = widget.recipt[0].boughtDate!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(children: [
              const Text("Paragon z dnia", style: TextStyle(fontSize: 20),),
              TextButton(
                onPressed: () async => await _selectDate(context), 
                child: Text(DateFormat('dd.MM.yyyy').format(shoppingDate), style: TextStyle(fontSize: 20),))
            ],),
            Expanded(
              child: ReciptList(
                scrollController: scrollController,
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
                    return TwoInputDialog(
                      formKey: formKey,
                      firstInput: nameController, 
                      firstInputMessage: "Pole nie może być puste",
                      secoundInput: priceController, 
                      secoundInputMessage: "Podaj cenę",
                      submitButtonText: "Edytuj",
                      submitHandler: () => edit(itemToEdit, formKey));});
                },
                recipt: widget.recipt
              ),
            )],
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

        showDialog(context: context, builder: (context) => 
          TwoInputDialog(
            formKey: formKey, 
            firstInput: nameController, 
            firstInputMessage: "Pole nie może być puste", 
            secoundInput: priceController,
            secoundInputMessage: "Podaj cenę", 
            submitButtonText: "Zatwierdź", 
            submitHandler: () => addItem(nameController.text, priceController.text, formKey)));
      },
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

    // this loop adds animation while items are deleting
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
      .map((e) => BoughtProduct(id: 0, name: e.data.name, price: e.data.price, boughtDate: shoppingDate)).toList());
    widget.recipt.clear();
    setState(() { });
  }

  void deleteSelectedItemsDialog() {
    showDialog(context: context, builder: ((context) => 
      YesNoDialog(
        title: "Usuń",
        description: "Jesteś pewny, że chcesz usunąć ${reciptKey.currentState!.searchableBoughtProducts.where((element) => element.isSelected).length} poduktów?",
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
        title: "Zapisanie danych",
        description: "Czy chcesz zapisać dane?",
        onYesClickAction: () {
          saveItems();
          Navigator.of(context).pop();
        },
        onNoClickAction: () {
          Navigator.of(context).pop();
        },
      )));
  }

  void addItem(String name, String price, GlobalKey<FormState> key) async {
    if(key.currentState!.validate()) {
      var boughtProduct = BoughtProduct(name: name, price: double.parse(price));
      widget.recipt.add(boughtProduct);
      reciptKey.currentState!.widget.selectableItems.add(SelectableItem(boughtProduct));
      reciptKey.currentState!.searchableBoughtProducts.insert(0, SelectableItem(boughtProduct));
      Navigator.of(context).pop();
      await scrollController.animateTo(0.0, duration: Duration(milliseconds: 1000), curve: Curves.easeOut);
      listKey.currentState!.insertItem(0, duration: Duration(milliseconds: 500));
      setState(() { });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale("pl", "PL"),
      initialDate: shoppingDate, 
      firstDate: DateTime(2015, 8), 
      lastDate: DateTime(2101, 8));
    if(picked != null) {
      shoppingDate = picked;
      setState(() { });
    }
  }
}