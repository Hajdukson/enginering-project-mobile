// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/generics/models/selectable_item_.dart';
import 'package:money_manager_mobile/widgets/generics/selectable_list.dart';
import 'package:money_manager_mobile/widgets/menu/menu.dart';
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

  late DateTime? shoppingDate;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
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
              Navigator.of(context).pop(Menu());
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
    var products = reciptKey.currentState!.searchableItems;
    var selectedProducts = products.where((element) => element.isSelected).toList();
    var numberOfSelectedProducts = selectedProducts.length;

    // This finally fixed a bug that cached deleted items from searchable list
    var keys = selectedProducts.map((e) => e.data.keyHelper).toList();

    reciptKey.currentState!.widget.selectableItems
      .removeWhere((item) => keys.any((key) => item.data.keyHelper == key));

    // This loop adds animation while items are deleting
    for(var i = 0; i < numberOfSelectedProducts; i++) {
      var product = products.firstWhere((element) => element.isSelected);

      listKey.currentState!.removeItem(products.indexOf(product), (context, animation) 
        => BoughtProductTail(product: product as SelectableItem<BoughtProduct>, animation: animation,));
      
      products.remove(product);
    }
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
    reciptKey.currentState!.widget.selectableItems.clear();
    reciptKey.currentState!.searchableItems.clear();
    setState(() { });
    Navigator.of(context).pop(Menu());
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
        },
        onNoClickAction: () {
          Navigator.of(context).pop();
        },
      )));
  }

  void addItem(String name, String price, GlobalKey<FormState> key) async {
    if(key.currentState!.validate()) {
      var boughtProduct = BoughtProduct(name: name, price: double.parse(price));
      Navigator.of(context).pop();
      await scrollController.animateTo(0.0, duration: Duration(milliseconds: 1000), curve: Curves.easeOut);
      var selectableItems = reciptKey.currentState!.widget.selectableItems as List<SelectableItem<BoughtProduct>>;
      selectableItems.add(SelectableItem(boughtProduct));
      var searchableItems = reciptKey.currentState!.searchableItems;
      searchableItems.insert(0, SelectableItem(boughtProduct) as SelectableItem<dynamic>);
      listKey.currentState!.insertItem(0, duration: Duration(milliseconds: 500));
      setState(() { });
    }
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
}