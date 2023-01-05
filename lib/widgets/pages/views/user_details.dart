import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/generics/selectable_list.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/product_summary_list.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late Future<List<ProductSummary>> futureProductsSummaries;
  final productSummaryKey = GlobalKey<SelectableListState>();

  @override
  void initState() {
    super.initState();
    futureProductsSummaries = BoughtProductsApi.getPrductsSummaries();
  }
  
  @override
  Widget build(BuildContext context) {
    final expandableController = ExpandableController();

    void expandFilters(ExpandableController controller) {
      controller.toggle();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Raport")),
       leading: IconButton(onPressed: () {}, icon: Icon(Icons.navigate_before,)),
       actions: [
        TextButton(
          onPressed: () { 
            expandFilters(expandableController);
          }, 
          child: Row(children: [
            const Icon(Icons.filter_alt, color: Colors.white,),
            Text("Filtry", style: Theme.of(context).textTheme.titleMedium,), 
          ])
      )],
      ),
      body: SafeArea(
        child: FutureBuilder<List<ProductSummary>>(
          future: futureProductsSummaries,
          builder: ((context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              if(snapshot.hasData) {
                return ProductSummaryList(
                  expandableController: expandableController,
                  key: productSummaryKey,
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