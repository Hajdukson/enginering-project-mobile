import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/generics/selectable_list.dart';
import 'package:money_manager_mobile/widgets/pages/views/product_details_view.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/product_summary_list.dart';

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
        title: const Center(child: Text("Raport")),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.navigate_before,)),
        actions: [
          TextButton(
            onPressed: () { 
              expandableController.toggle();
            }, 
            child: Row(children: [
              const Icon(Icons.filter_alt, color: Colors.white,),
              Text("Filtry", style: Theme.of(context).textTheme.titleMedium,), 
            ])
          )]),
      body: SafeArea(
        child: FutureBuilder<List<ProductSummary>>(
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
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
          }))));
  }

  void navigate(BuildContext context, dynamic productName) {     
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailsView(productSummary: productName,),
    ),);
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