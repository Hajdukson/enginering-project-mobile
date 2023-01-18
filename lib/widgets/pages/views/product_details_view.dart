import 'package:flutter/material.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/chart.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/details_chart_tile.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({Key? key, required this.productSummary}) : super(key: key);
  final ProductSummary productSummary;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late Future<List<BoughtProduct>> boughtProducts;

  bool isQuestionMarkClicked = false;

  var detailsKey = GlobalKey<DetailsChartTileState>();

  @override
  void initState() {
    boughtProducts = BoughtProductsApi.getProducts(name: widget.productSummary.productName);
    super.initState();
  }

  var chartKey = GlobalKey<ChartState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Szczegóły")),),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30,),
              FutureBuilder<List<BoughtProduct>>(
                future: boughtProducts,
                builder: ((context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    if(snapshot.hasData) {
                      return DetailsChartTile(
                        key: detailsKey,
                        isQuestionMarkClicked: isQuestionMarkClicked, 
                        productSummary: widget.productSummary, 
                        boughtProducts: snapshot.data!);
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
              } )),
              const SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Divider(thickness: 2, color: Color.fromARGB(95, 255, 255, 255),),),
            ],),
        ),
      ),
    );
  }
}