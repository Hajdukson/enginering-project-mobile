import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/generics/selectable_list.dart';
import 'package:money_manager_mobile/menu/menu.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';
import 'package:money_manager_mobile/widgets/dialogs/date_input_dialog.dart';
import 'package:money_manager_mobile/widgets/dialogs/yesno_dialog.dart';
import 'package:money_manager_mobile/widgets/fab/action_button.dart';
import 'package:money_manager_mobile/widgets/lists/details_product_list.dart';
import 'package:money_manager_mobile/widgets/tiles/bought_product_tile.dart';

class DetailsProductListTabView extends StatefulWidget {
  DetailsProductListTabView({
    Key? key,
    required this.productName,
    required this.boughtProducts,
    }) : super(key: key);

  List<SelectableItem<BoughtProduct>> boughtProducts;
  String productName;

  @override
  State<DetailsProductListTabView> createState() => _DetailsProductListTabViewState();
}

class _DetailsProductListTabViewState extends State<DetailsProductListTabView> 
    with AutomaticKeepAliveClientMixin<DetailsProductListTabView>{

  @override
  bool get wantKeepAlive => true;

  final listKey = GlobalKey<SelectableListState>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DetailsProductList(
      key: listKey,
      boughtProducts: widget.boughtProducts,
      setChildState: setChildState,
      onBulkActions: bulkActions,
      noBulkActions: nobulkActions,
      editProduct: edit,
    );
  }

  List<ActionButton> get bulkActions => [
    ActionButton(
      icon: const Icon(Icons.delete),
      onPressed: showConfirmDeleteDialog,),
  ];

  List<ActionButton> get nobulkActions => [
    ActionButton(
      icon: const Icon(Icons.add),
      onPressed: showAddPorductDialog,),
  ];

  void showAddPorductDialog() async {
    final dialgoKey = GlobalKey<DateInputDialogState>();
    final formKey = GlobalKey<FormState>();
    await showDialog<BoughtProduct>(context: context, builder: ((context) => 
      DateInputDialog(
        key: dialgoKey,
        formKey: formKey,
        textInputLabel: "Cena",
        submit: () {
          if(formKey.currentState!.validate()) {
            addProduct(dialgoKey.currentState!.textController.text, dialgoKey.currentState!.selectedDate!);
          }
        },
    )));
    
  }

  void showConfirmDeleteDialog() async {
    var selectedProducts = listKey.currentState!.searchableItems.where((item) => item.isSelected).toList();

    await showDialog(
      context: context, 
      builder: (context) => 
        YesNoDialog(
          title: "Usuń",
          description: "Jesteś pewny że chcesz usunąć ${selectedProducts.length} ${selectedProducts.length == 1 ? "product" : selectedProducts.length >= 5 ? "produktó" : "produkty"}?",
          onYesClickAction: () async {
            Navigator.of(context).pop();
            await deleteSelected(selectedProducts);
          },
          onNoClickAction: () {
            Navigator.of(context).pop();
          },
    ));
  }

  void addProduct(String price, DateTime dateTime) async {
    var boughtPorduct = BoughtProduct(name: widget.productName, price: double.parse(price), boughtDate: dateTime);

    Navigator.of(context).pop();

    try {
      BoughtProduct responseProduct = await BoughtProductsApi.postSingeProduct(boughtPorduct);
      widget.boughtProducts.insert(0, SelectableItem(responseProduct));
      if(listKey.currentState!.searchableItems.isNotEmpty) {
        listKey.currentState!.animateInsert(SelectableItem<BoughtProduct>(responseProduct));
      }
      setState(() { });
    } catch (e) {
      // showDialog(context: context, builder: ((context) => InfoDialog(icon, dialogContent: dialogContent, height: height, width: width)))
    }
  }

  Future<void> deleteSelected(List<SelectableItem<dynamic>> selectedProducts) async {
    listKey.currentState!.animateAndRemoveSelected((product, animation) => BoughtProductTail(product: product as SelectableItem<BoughtProduct>, animation: animation));
    
    for (var product in selectedProducts) {
      var deletedProduct = await BoughtProductsApi.deleteProduct(product.data);
      widget.boughtProducts.removeWhere((product) => product.data.id == deletedProduct.id);
    }

    if(widget.boughtProducts.isEmpty) {
      navigateToMenu();
    }

    setState(() { });
  }


  /// According to https://stackoverflow.com/questions/61424636/flutter-looking-up-a-deactivated-widgets-ancestor-is-unsafe
  void navigateToMenu() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Menu()),
        (Route<dynamic> route) => false,
      );
    }); 
  }

  void setChildState(dynamic expression) {
    listKey.currentState!.setState(() {
      expression;
    });
  }

  void edit(BoughtProduct boughtProduct) {
    final dialgoKey = GlobalKey<DateInputDialogState>();
    final formKey = GlobalKey<FormState>();
    showDialog(context: context, builder: (context) {
      return DateInputDialog(
        initialDate: boughtProduct.boughtDate,
        initialText: boughtProduct.price.toString(),        
        key: dialgoKey,
        formKey: formKey,
        textInputLabel: "Cena",
        submit: () async {
          if(formKey.currentState!.validate()) {
            Navigator.of(context).pop();
            boughtProduct.price = double.parse(dialgoKey.currentState!.textController.text);
            boughtProduct.boughtDate = dialgoKey.currentState!.selectedDate;
            await BoughtProductsApi.editProduct(boughtProduct);
            setState(() { }); 
          }
        },
    );});
  }
}