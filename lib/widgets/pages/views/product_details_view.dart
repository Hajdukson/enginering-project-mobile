import 'package:flutter/material.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/chart.dart';
import 'package:money_manager_mobile/extenstions/last_2_moth_products.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({Key? key, required this.productSummary}) : super(key: key);
  final ProductSummary productSummary;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late Future<List<BoughtProduct>> boughtProducts;

  late int year;
  late int month;
  bool isClicked = false;

  @override
  void initState() {
    boughtProducts = BoughtProductsApi.getProducts(name: widget.productSummary.productName).then((value) {
      year = value.last.boughtDate!.year;
      month = value.last.boughtDate!.month;
      return value;
    }, onError: (e) => print(e));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var chartKey = GlobalKey<ChartState>();
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Szczegóły")),),
      body: GestureDetector(
        onTap: () {
          if(isClicked) {
            isClicked = false;
            setState(() { });
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              FutureBuilder<List<BoughtProduct>>(
                future: boughtProducts,
                builder: ((context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    if(snapshot.hasData) {
                      return SizedBox(
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(255, 58, 61, 63),
                              Color.fromARGB(255, 58, 61, 63),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter
                            )
                          ),
                          child: Stack(
                            children: [
                              IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: Colors.white.withOpacity(isClicked ? 0.3 : 1.0),
                                onPressed: () {
                                  isClicked = !isClicked;
                                  setState(() {});
                                }, icon: const Icon(Icons.question_mark)),
                              Column(
                                children: [
                                  const SizedBox(height: 35,),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.shopping_bag),
                                        const SizedBox(width: 5),
                                        Text("${widget.productSummary.productName}", style: Theme.of(context).textTheme.titleLarge,),
                                    ],),
                                ),
                                Container(
                                margin: const EdgeInsets.all(10),
                                height: 250,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20,right: 30, left: 30),
                                  child: Chart(key: chartKey ,snapshot.data!.getProductFromLast2Month(month, year))),
                                ),
                                const SizedBox(height: 30,),
                                SizedBox(
                                  height: 50,
                                  child: Text("Ceny z roku $year", style: Theme.of(context).textTheme.titleMedium,),
                                  )]
                                ),
                                Positioned(
                                  top: 160,
                                  left: -20,
                                  child: IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: () {
                                      chartKey.currentState?.showingTooltipSpot = -1;
                                      month--;
                                      setState(() {});
                                    }, 
                                    icon: const Icon(Icons.chevron_left, size: 50)),
                                ),
                                Positioned(
                                  top: 160,
                                  right: 0,
                                  child: IconButton(                                    
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: () {
                                      chartKey.currentState?.showingTooltipSpot = -1;
                                      month++;
                                      setState(() {});
                                    }, 
                                    icon: const Icon(Icons.navigate_next, size: 50,)),  
                                )
                                ],
                          )),
                      );
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