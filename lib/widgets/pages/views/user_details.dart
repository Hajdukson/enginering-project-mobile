import 'package:flutter/material.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/product_summary_list.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late Future<List<ProductSummary>> futureProductsSummaries;

  @override
  void initState() {
    super.initState();
    futureProductsSummaries = BoughtProductsApi.getPrductsSummaries();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<ProductSummary>>(
          future: futureProductsSummaries,
          builder: ((context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              if(snapshot.hasData) {
                return ProductSummaryList(
                  filterHandler: ((p0, p1, p2) {}),
                  productsSummaries: snapshot.data!,
                );
              }
            }
            return const CircularProgressIndicator();
          }))));
  }
// TODO - obsługa argumentów endpointu getProductsSummaries
}