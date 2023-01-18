import 'package:flutter/material.dart';
import 'package:money_manager_mobile/extenstions/last_2_moth_products.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/chart.dart';
import 'package:money_manager_mobile/widgets/pages/widgets/dialogs/info_dialog.dart';

class DetailsChartTile extends StatefulWidget {
  DetailsChartTile({Key? key, 
    required this.isQuestionMarkClicked, 
    required this.productSummary, 
    required this.boughtProducts}) : super(key: key);

  bool isQuestionMarkClicked;
  ProductSummary productSummary;
  List<BoughtProduct> boughtProducts;

  @override
  State<DetailsChartTile> createState() => DetailsChartTileState();
}

class DetailsChartTileState extends State<DetailsChartTile> {
  var chartKey = GlobalKey<ChartState>();
  late int year;
  late int month;

  @override
  void initState() {
    year = widget.boughtProducts.last.boughtDate!.year;
    month = widget.boughtProducts.last.boughtDate!.month;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.white.withOpacity(widget.isQuestionMarkClicked ? 0.3 : 1.0),
                    icon: const Icon(Icons.question_mark),
                    onPressed: () {
                      showDialog(context: context, builder: (context) => InfoDialog(
                        Icons.question_mark,
                        height: 300,
                        width: 300,
                        dialogContent: dialogContent,));
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
                        child: Chart(key: chartKey ,widget.boughtProducts.getProductFromLast2Month(month, year))),
                    ),
                    const SizedBox(height: 30,),
                    SizedBox(
                      height: 50,
                      child: Text(month == 1 ? "Ceny z lat ${year - 1} - $year" : "Ceny z roku $year", style: Theme.of(context).textTheme.titleMedium,),
                      )]
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
          );
  }

  void showDialogOnEdgeOfProductList(BuildContext context) {
    showDialog(context: context, builder: (context) => const InfoDialog(
        Icons.priority_high,
        dialogContent: [
          SizedBox(height: 35,),
          Text("Nie można znaźć więcej prodktów", style: TextStyle(fontSize: 16),),
        ],
        height: 200,
        width: 350,
        ));
  }

  List<Widget> get dialogContent => [
    const SizedBox(height: 30,),
    RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(fontSize: 16),
        text: "Kliknij na załamania wykresu, aby sprawdzić szczegóły.")
    ),
    const SizedBox(height: 20,),
    Wrap(
      alignment: WrapAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 16),
                text: "Użyj")
            ),
            const Icon(Icons.chevron_left),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 16),
                text: "lub")
            ),
            const Icon(Icons.navigate_next),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(fontSize: 16),
              text: "aby przesunąć wykres o jeden miesiąc.")
          ),
        ),
      ],
    ),
    const SizedBox(height: 20,),
  ];
}