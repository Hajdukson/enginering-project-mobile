import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/flavor/flavor_config.dart';
import 'package:money_manager_mobile/generics/selectable_list.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';
import 'package:money_manager_mobile/views/product_details_view.dart';
import 'package:money_manager_mobile/widgets/dialogs/new_product_dialog.dart';
import 'package:money_manager_mobile/widgets/fab/action_button.dart';
import 'package:money_manager_mobile/widgets/lists/product_summary_list.dart';
import 'package:money_manager_mobile/widgets/tiles/product_summary_tile.dart';

class ProductsSummaryView extends StatefulWidget {
  const ProductsSummaryView({Key? key}) : super(key: key);

  @override
  State<ProductsSummaryView> createState() => _ProductsSummaryViewState();
}

class _ProductsSummaryViewState extends State<ProductsSummaryView> with SingleTickerProviderStateMixin {
  late Future<List<ProductSummary>> futureProductsSummaries;
  final productSummaryKey = GlobalKey<SelectableListState>();
  final expandableController = ExpandableController();

  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    futureProductsSummaries = BoughtProductsApi.getPrductsSummaries();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Ustawienia")),
                Row(children: [
                    Image.asset('assets/images/pl_flag.png', scale: 9.0,),
                    Radio(value: null, groupValue: null, onChanged: null),
                    Image.asset('assets/images/uk_flag.png', scale: 9.0,),
                    Radio(value: null, groupValue: null, onChanged: null)
                ],),
                Row(children: [
                  Icon(FlavorConfig.instance.values.themeNotifier.isDarkMode ? Icons.dark_mode : Icons.light_mode),
                  Switch(value: FlavorConfig.instance.values.themeNotifier.isDarkMode, onChanged: (value){
                    darkMode = value;
                    if(darkMode){
                      FlavorConfig.instance.values.themeNotifier.setDarkMode();
                    } else {
                      FlavorConfig.instance.values.themeNotifier.setLightMode();
                    }
                    setState(() { });
                  })
                ],)
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () { 
              expandableController.toggle();
            }, 
            child: Row(children: [
              Icon(Icons.filter_alt, color: Theme.of(context).primaryColorDark,),
              Text("Filtrowanie", style: Theme.of(context).textTheme.titleMedium,), 
            ])
          )]),
      body: FutureBuilder<List<ProductSummary>>(
        future: futureProductsSummaries,
        builder: ((context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasData) {
              return ProductSummaryList(
                expandableController: expandableController,
                key: productSummaryKey,
                navigateHandler: navigate,
                setChildState: setChildState,
                filterHandler: runFilter,
                clearFilerHandler: clearFiler,
                productsSummaries: snapshot.data!.map((e) => SelectableItem(e)).toList(),
                onBulkActions: bulkActions,
                noBulkActions: actions,
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        })));
  }

  List<ActionButton> get bulkActions => [
    ActionButton(
      icon: const Icon(Icons.delete),
      onPressed: deleteSelectedProducts
      )
  ];

  List<ActionButton> get actions => [
    ActionButton(
      icon: const Icon(Icons.add),
      onPressed: addProductDialog,
    )
  ];

  void addProductDialog() async {
    await showDialog(context: context, builder: (contex) {
      return NewProductDialog(
        addProductCall: addProduct,
      );
    });
  }

  void addProduct(String name, String price, DateTime boughtDate) async {
    Navigator.of(context).pop();
    var boughtProduct = BoughtProduct(id: 0, name: name, price: double.parse(price), boughtDate: boughtDate); 
    await BoughtProductsApi.postSingeProduct(boughtProduct);
    futureProductsSummaries = BoughtProductsApi.getPrductsSummaries();
    setState(() {});
  }

  void deleteSelectedProducts() async {
    var products = productSummaryKey.currentState!.searchableItems.where((product) => product.isSelected).cast<SelectableItem<ProductSummary>>().toList();
    var productsNames = products.map((e) => e.data.productName!).toList();
    productSummaryKey.currentState!.animateAndRemoveSelected((item, animation) => ProductSummaryTile(productSummary: item as SelectableItem<ProductSummary>, animation: animation,));
    await BoughtProductsApi.deleteProductsByName(productsNames);

    setState(() { });
  }

  void navigate(BuildContext context, dynamic productName) {     
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsView(productSummary: productName,),
    ),
    );
  }

  void clearFiler() {
    futureProductsSummaries = BoughtProductsApi.getPrductsSummaries();
    setState(() { });
  }

  void runFilter(String? name, DateTimeRange? dates) {
    futureProductsSummaries = BoughtProductsApi.getPrductsSummaries(name: name, dates: dates);
    setState(() { });
  }

  void setChildState(dynamic expression) {
    productSummaryKey.currentState!.setState(() {
      expression;
    });
  }
}