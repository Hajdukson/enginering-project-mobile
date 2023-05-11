import 'package:flutter/material.dart';
import 'package:money_manager_mobile/extenstions/last_2_moth_products.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';
import 'package:money_manager_mobile/theming/custom_colors.dart';
import 'package:money_manager_mobile/widgets/chart.dart';
import 'package:money_manager_mobile/widgets/dialogs/info_dialog.dart';
import 'package:money_manager_mobile/widgets/no_products.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DetailsChartTile extends StatefulWidget {
  DetailsChartTile({Key? key, 
    required this.productSummary, 
    required this.boughtProducts}) : super(key: key);

  ProductSummary productSummary;
  List<BoughtProduct> boughtProducts;

  @override
  State<DetailsChartTile> createState() => DetailsChartTileState();
}

class DetailsChartTileState extends State<DetailsChartTile> {
  late final texts = AppLocalizations.of(context)!;
  var chartKey = GlobalKey<ChartState>();
  late int year;
  late int month;

  @override
  void initState() {
    if(widget.boughtProducts.isNotEmpty) {
      year = widget.boughtProducts.last.boughtDate!.year;
      month = widget.boughtProducts.last.boughtDate!.month;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.boughtProducts.isNotEmpty ? SizedBox(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(18)),
                gradient: LinearGradient(colors: [
                  ...CustomColors.themeColors.chartColor
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
                    color: CustomColors.backgroundColorSecondary,
                    icon: const Icon(Icons.question_mark),
                    onPressed: () {
                      showDialog(context: context, builder: (context) => InfoDialog(
                        Icons.question_mark,
                        height: 300,
                        width: 300,
                        dialogContent: dialogContent(),));
                    }), 
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
                        child: Chart(key: chartKey ,widget.boughtProducts.getProductsFromLast2Month(month, year))),
                    ),
                    const SizedBox(height: 30,),
                    SizedBox(
                      height: 50,
                      child: Text(month == 1 ? "${texts.yearsPrices} ${year - 1} - $year" : "${texts.yearPrices} $year", style: Theme.of(context).textTheme.titleMedium,),
                      )
                    ]
                    ),
                    Positioned(
                      top: 160,
                      left: -20,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          if(widget.boughtProducts.any((bp) => bp.boughtDate?.month == month - 1)) {
                            chartKey.currentState?.showingTooltipSpot = -1;
                            setState(() {
                              month--;
                            });
                          } else {
                            showDialogOnEdgeOfProductList(context);
                          }
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
                          if(widget.boughtProducts.any((bp) => bp.boughtDate?.month == month + 1)) {
                            chartKey.currentState?.showingTooltipSpot = -1;
                            setState(() {
                              month++;
                            });
                          } else {
                            showDialogOnEdgeOfProductList(context);
                          }
                        }, 
                        icon: const Icon(Icons.navigate_next, size: 50,)),  
                    )
                    ],
              )),
          ) : NoProducts(items: widget.boughtProducts.map((e) => SelectableItem(e)).toList());
  }

  void showDialogOnEdgeOfProductList(BuildContext context) {
    showDialog(context: context, builder: (context) => InfoDialog(
        Icons.priority_high,
        dialogContent: [
          Expanded(child: Center(child: Text(texts.couldNotFindProducts, style: const TextStyle(fontSize: 16),))),
        ],
        height: 200,
        width: 350,
        ));
  }

  List<Widget> dialogContent() {
    final fontStyle = TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 16);
    return 
    [
      const SizedBox(height: 30,),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: fontStyle,
            text: texts.clickOnChart)
        ),
      ),
      const SizedBox(height: 20,),
      Expanded(
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: fontStyle,
                      text: texts.use)
                  ),
                  const Icon(Icons.chevron_left),
                  RichText(
                    text: TextSpan(
                      style: fontStyle,
                      text: texts.or)
                  ),
                  const Icon(Icons.navigate_next),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: fontStyle,
                    text: texts.toMoveChart)
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20,),
    ];
  }
}