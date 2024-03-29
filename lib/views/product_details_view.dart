import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/generics/selectable_list.dart';
import 'package:money_manager_mobile/menu/menu.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';
import 'package:money_manager_mobile/views/details_product_chart_tab_view.dart';
import 'package:money_manager_mobile/views/details_product_list_tab_view.dart';
import 'package:money_manager_mobile/widgets/chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({Key? key, required this.productSummary}) : super(key: key);
  final ProductSummary productSummary;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  _ProductDetailsViewState();

  late Future<List<BoughtProduct>> boughtProducts;

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
    final texts = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: (() => SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const Menu()),
                (Route<dynamic> route) => false,);
              }))),
            title: Text(texts.product),
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
                          labelColor: Theme.of(context).primaryColorDark,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ),
                            color: Theme.of(context).primaryColor,
                          ),
                          tabs: [
                            Tab(text: texts.details,),
                            Tab(text: texts.list),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: DetailsProductChartTabView(productSummary: widget.productSummary, boughtProducts: snapshot.data!,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: DetailsProductListTabView(
                                key: detailsProductListKey,
                                productName: widget.productSummary.productName!,
                                boughtProducts: snapshot.data!.map((e) => SelectableItem(e)).toList(),))
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
}