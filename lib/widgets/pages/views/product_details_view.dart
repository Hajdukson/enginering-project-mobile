import 'package:flutter/material.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/chart.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({Key? key, required this.productSummary}) : super(key: key);
  final ProductSummary productSummary;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late Future<List<BoughtProduct>> boughtProducts;
  @override
  void initState() {
    boughtProducts = BoughtProductsApi.getProducts(name: widget.productSummary.productName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Szczegóły"),),),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Center(child: Text("${widget.productSummary.productName}")),
            FutureBuilder<List<BoughtProduct>>(
              future: boughtProducts,
              builder: ((context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  if(snapshot.hasData) {
                    return Chart(snapshot.data as List<BoughtProduct>);
                  }
                }
                return const Center(child: CircularProgressIndicator());
            } ))
          ],),
      ),
    );
  }
}