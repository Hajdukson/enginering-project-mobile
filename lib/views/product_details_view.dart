import 'package:flutter/material.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/generics/selectable_list.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/chart.dart';
import 'package:money_manager_mobile/widgets/lists/details_product_list.dart';
import 'package:money_manager_mobile/widgets/tiles/details_chart_tile.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({Key? key, required this.productSummary}) : super(key: key);
  final ProductSummary productSummary;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late Future<List<BoughtProduct>> boughtProducts;

  final detailsKey = GlobalKey<DetailsChartTileState>();

  @override
  void initState() {
    boughtProducts = BoughtProductsApi.getProducts(name: widget.productSummary.productName);
    super.initState();
  }

  final chartKey = GlobalKey<ChartState>();
  final listKey = GlobalKey<AnimatedListState>();
  final detailsProductListKey = GlobalKey<SelectableListState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Produkt"),
          ),
        body: FutureBuilder<List<BoughtProduct>>(
          future: boughtProducts,
          builder: ((context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              if(snapshot.hasData) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                      child: TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            25.0,
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                        tabs: const [
                          Tab(text: "Szczegóły",),
                          Tab(text: "Lista"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: DetailsChartTile(productSummary: widget.productSummary, boughtProducts: snapshot.data!)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: DetailsProductList(
                              setChildState: setChildState,
                              key: detailsProductListKey,
                              boughtProducts: snapshot.data!, 
                              listKey: listKey)),
                        ],),
                    ),
                  ],
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
        } )),
      ),
    );
  }

  void setChildState(dynamic expression) {
    detailsProductListKey.currentState!.setState(() {
      expression;
    });
  }
}