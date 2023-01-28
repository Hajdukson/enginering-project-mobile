import 'package:flutter/material.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/generics/selectable_list.dart';
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

  List<BoughtProduct> boughtProducts;
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

    showDialog(
      context: context, 
      builder: (context) => 
        YesNoDialog(
          title: "Usuń",
          description: "Jesteś pewny że chcesz usunąć ${selectedProducts.length} ${selectedProducts.length == 1 ? "product" : selectedProducts.length >= 5 ? "produktó" : "produkty"}?",
          onYesClickAction: () {
            deleteSelected(selectedProducts);
            Navigator.of(context).pop();
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
      widget.boughtProducts.insert(0, responseProduct);
      if(listKey.currentState!.searchableItems.isNotEmpty) {
        listKey.currentState!.animateInsert(SelectableItem<BoughtProduct>(responseProduct));
      }
      setState(() { });
    } catch (e) {
      // showDialog(context: context, builder: ((context) => InfoDialog(icon, dialogContent: dialogContent, height: height, width: width)))
    }
  }

  void deleteSelected(List<SelectableItem<dynamic>> selectedProducts) async {
    for (var product in selectedProducts) {
      await BoughtProductsApi.deleteProduct(product.data);  
    }

    listKey.currentState!.animateAndRemoveSelected((product, animation) => BoughtProductTail(product: product as SelectableItem<BoughtProduct>, animation: animation));

    widget.boughtProducts.clear();
    widget.boughtProducts.addAll(listKey.currentState!.widget.selectableItems.map((e) => BoughtProduct(id: e.data.id ,name: e.data.name, price: e.data.price, boughtDate: e.data.boughtDate,)));

    setState(() { });
  }

  void setChildState(dynamic expression) {
    listKey.currentState!.setState(() {
      expression;
    });
  }
}