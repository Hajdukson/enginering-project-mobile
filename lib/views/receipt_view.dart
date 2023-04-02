// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/generics/selectable_list.dart';
import 'package:money_manager_mobile/menu/menu.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';
import 'package:money_manager_mobile/widgets/dialogs/info_dialog.dart';
import 'package:money_manager_mobile/widgets/dialogs/two_input_dialog.dart';
import 'package:money_manager_mobile/widgets/dialogs/yesno_dialog.dart';
import 'package:money_manager_mobile/widgets/fab/action_button.dart';
import 'package:money_manager_mobile/widgets/lists/recipt_list.dart';
import 'package:money_manager_mobile/widgets/tiles/bought_product_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReceiptView extends StatefulWidget {
  ReceiptView({Key? key, required this.recipt, }) : super(key: key);

  List<SelectableItem<BoughtProduct>> recipt;
  DateTime? shoppingDate;

  @override
  State<ReceiptView> createState() => ReceiptViewState();
}

class ReceiptViewState extends State<ReceiptView> {
  final reciptKey = GlobalKey<SelectableListState>();
  late final texts = AppLocalizations.of(context)!;
  var nameController = TextEditingController();
  var priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.recipt.isNotEmpty && widget.shoppingDate == null) {
      widget.shoppingDate = widget.recipt.first.data.boughtDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool result = false;
        showDialog(context: context, builder: ((context) => 
          YesNoDialog(
            description: texts.movingBack,
            onNoClickAction: () {
              result = false;
              Navigator.of(context).pop();
            },
            onYesClickAction: () async {
              result = true;
              await BoughtProductsApi.deleteImage(widget.recipt.first.data.imagePath!);
              if(!mounted) return;
              Navigator.of(context).pop();
              Navigator.of(context).pop(const Menu());
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
                Text(texts.receiptDate , style: TextStyle(fontSize: 20),),
                TextButton(
                  onPressed: () async => await _selectDate(context), 
                  child: Text(widget.shoppingDate != null ? DateFormat('dd.MM.yyyy').format(widget.shoppingDate!) : texts.empty, style: TextStyle(fontSize: 20),))
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
                          label: Text(texts.name),
                        ),  
                        controller: nameController,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return texts.fieldCannotBeEmpty;
                          }
                          return null;
                        },
                      );
                      final secondInput = TextFormField(
                        decoration: InputDecoration(
                          label: Text(texts.price)
                        ),
                        controller: priceController,
                        validator: (value) {
                          if(double.tryParse(value!) == null || value.isEmpty) {
                            return texts.enterPrice;
                          }
                          return null;
                        },
                      );
                      return TwoInputDialog(
                        formKey: formKey,
                        firstInput: firstInput,
                        secondInput: secondInput,
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

        showDialog(context: context, builder: (context) {
          final firstInput = TextFormField(
            decoration: InputDecoration(
              label: Text(texts.name),
            ),  
            controller: nameController,
            validator: (value) {
              if(value == null || value.isEmpty) {
                return texts.fieldCannotBeEmpty;
              }
              return null;
            },
          );
          final secondInput = TextFormField(
            decoration: InputDecoration(
              label: Text(texts.price)
            ),
            controller: priceController,
            validator: (value) {
              if(double.tryParse(value!) == null || value.isEmpty) {
                return texts.enterPrice;
              }
              return null;
            },
          );
          return TwoInputDialog(
            formKey: formKey,
            firstInput: firstInput,
            secondInput: secondInput,
            submitHandler: () async => await addItem(nameController.text, priceController.text, formKey));});
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
  
  Future<bool> addItem(String name, String price, GlobalKey<FormState> key) async {
    if(key.currentState!.validate()) {
      var boughtProduct = SelectableItem(BoughtProduct(name: name, price: double.parse(price)));
      Navigator.of(context).pop();
      await reciptKey.currentState!.animateInsert(boughtProduct);
      widget.recipt.insert(0, boughtProduct);
      setState(() { });
      return true;
    }
    return false;
  }

  void deleteSelectedItems() async {
    var imagePath = widget.recipt.first.data.imagePath;
    reciptKey.currentState!.animateAndRemoveSelected((item, animation) =>
          BoughtProductTail(product: item as SelectableItem<BoughtProduct>, animation: animation,));
    widget.recipt.removeWhere((element) => element.isSelected);

    if(widget.recipt.isEmpty) {
      widget.shoppingDate = null;

      if(imagePath != null) {
        await BoughtProductsApi.deleteImage(imagePath);
      }
    }

    setState(() {  });
  }

  void abortAction() async {
    await BoughtProductsApi.deleteImage(widget.recipt.first.data.imagePath!);
    widget.recipt.clear();
    setState(() { });
    reciptKey.currentState!.removeAllItems();
    _navigateToMenu();
  }

  void saveItems() async {
    await BoughtProductsApi.postProducts(widget.recipt.map((e) {
      e.data.id = 0;
      e.data.boughtDate = widget.shoppingDate;
      return e.data;
    }).toList());
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
        title: texts.delet,
        description: "${texts.deletingProducts} $selectedProducts ${selectedProducts == 1 ? texts.product.toLowerCase() : 
          Intl.getCurrentLocale() == "pl" ? 
            (selectedProducts >= 5 ? "produktów" : "produkty") 
              : "products"}?",
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
        title: texts.abortData,
        description: texts.abortDataMessage,
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
    var textStyle = TextStyle(fontSize: 16, color: Theme.of(context).primaryColorDark);
    if(widget.shoppingDate == null || widget.recipt.isEmpty) {
      showDialog(context: context, builder: ((context) => InfoDialog(
        Icons.priority_high, 
        dialogContent: [
          if(widget.shoppingDate == null)
            Expanded(
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: textStyle,
                    text: texts.enterDataFromReceipt)
                ),
              ),
            ),
          if(widget.recipt.isEmpty)
            Expanded(
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: textStyle,
                    text: texts.youHaveToAddProduct)
                ),
              ),
            ),
        ], 
        height: 250, width: 250)));
        return;
    }
    showDialog(context: context, builder: ((context) => 
      YesNoDialog(
        title: texts.saveData,
        description: texts.areYouSureAbSavingData,
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
      initialDate: widget.shoppingDate ?? DateTime.now(), 
      firstDate: DateTime(2015, 8), 
      lastDate: DateTime(2101, 8));
    if(picked != null) {
      widget.shoppingDate = picked;
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