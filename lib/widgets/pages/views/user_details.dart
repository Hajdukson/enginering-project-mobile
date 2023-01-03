import 'package:flutter/material.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/product_summary_list.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late Future<List<ProductSummary>> futureProductsSummaries;
  late Future<List<BoughtProduct>> futureBoughtProducts;
  @override
  void initState() {
    super.initState();
    futureProductsSummaries = BoughtProductsApi.getPrductsSummaries();
    futureBoughtProducts = BoughtProductsApi.getProducts();
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
                  productsSummaries: snapshot.data!,
                );
              }
            }
            return const CircularProgressIndicator();
          }))));
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(child:
  //      FutureBuilder<List<BoughtProduct>>(
  //       future: futureBoughtProducts,
  //       builder: ((context, snapshot) {
  //         if(snapshot.connectionState == ConnectionState.done) {
  //           if(snapshot.hasData) {
  //             return ListView.builder(
  //               itemCount: snapshot.data!.length,
  //               itemBuilder: ((context, index) => Text("${snapshot.data![index].name} / ${snapshot.data![index].price} / ${snapshot.data![index].boughtDate!.toIso8601String()}")));
  //           }
  //         }
  //         return const CircularProgressIndicator();
  //     }))));
  // }
}