import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/generics/selectable_list.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';
import 'package:money_manager_mobile/views/product_details_view.dart';
import 'package:money_manager_mobile/widgets/fab/action_button.dart';
import 'package:money_manager_mobile/widgets/lists/product_summary_list.dart';
import 'package:money_manager_mobile/widgets/tiles/product_summary_tile.dart';

class ProductsSummaryView extends StatefulWidget {
  const ProductsSummaryView({Key? key}) : super(key: key);

  @override
  State<ProductsSummaryView> createState() => _ProductsSummaryViewState();
}

class _ProductsSummaryViewState extends State<ProductsSummaryView> {
  late Future<List<ProductSummary>> futureProductsSummaries;
  final productSummaryKey = GlobalKey<SelectableListState>();
  final expandableController = ExpandableController();

  @override
  void initState() {
    super.initState();
    futureProductsSummaries = BoughtProductsApi.getPrductsSummaries();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.settings), onPressed: () {
          // expanded menu where user can change language and switch to darkmode
        },),
        actions: [
          TextButton(
            onPressed: () { 
              expandableController.toggle();
            }, 
            child: Row(children: [
              const Icon(Icons.filter_alt, color: Colors.white,),
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
                productsSummaries: snapshot.data!,
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

  ];

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