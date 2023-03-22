import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/menu/menu.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/product_summary.dart';
import 'package:money_manager_mobile/widgets/dialogs/yesno_dialog.dart';
import 'package:money_manager_mobile/widgets/tiles/details_chart_tile.dart';

class DetailsProductChartTabView extends StatefulWidget {
  const DetailsProductChartTabView({Key? key, required this.productSummary, required this.boughtProducts}) : super(key: key);
  final ProductSummary productSummary;
  final List<BoughtProduct> boughtProducts;

  @override
  State<DetailsProductChartTabView> createState() => _DetailsProductChartTabViewState();
}

class _DetailsProductChartTabViewState extends State<DetailsProductChartTabView> {
  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(5),
                          backgroundColor: MaterialStateProperty.all<Color>((Colors.blueGrey)),
                          shape:  MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )));
    return Column(children: [
      DetailsChartTile(productSummary: widget.productSummary, boughtProducts: widget.boughtProducts),
      const SizedBox(height: 20,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: showDeleteDialog, 
            style: buttonStyle,
            child: const Text("Usuń produkt"),),
          const SizedBox(width: 40,),
          ElevatedButton(onPressed: changeNameDialog, 
            style: buttonStyle,
            child: const Text("Zmień nazwę"))
      ],
      )
    ],);
  }

  void changeNameDialog() async {
    final formKey = GlobalKey<FormState>();
    final textController = TextEditingController(text: widget.productSummary.productName);

    await showDialog(context: context, builder: ((context) {
      return Dialog(
        child: Form(
          key: formKey,
          child: SizedBox(
            height: 170,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    validator: ((value) {
                      if(value == null || value.isEmpty) {
                        return "Podaj nazwę";
                      }
                      return null;
                    }),
                    controller: textController,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(onPressed: () async {
                          if(formKey.currentState!.validate()) {
                            Navigator.of(context).pop();
                            await changeName(textController.text);
                          }
                        },  
                        child: const Text("Zatwierdź")),
                    ),)
                ],
              ),
            ),
          )),
      );
    }));
  }

  void showDeleteDialog() async {
    showDialog(context: context, builder: ((context) {
      return YesNoDialog(
        title: "Usuń",
        description: "Czy na pewno chcesz usunąć ten produkt?",
        onYesClickAction: deleteProduct,
        onNoClickAction: () {
          Navigator.of(context).pop();
        },
      );
    }));
  }

  Future changeName(String name) async {
    showDialog(context: context, builder: ((context) => const Center(child: CircularProgressIndicator())));
    for (var product in widget.boughtProducts) {
      product.name = name;
      await BoughtProductsApi.editProduct(product);
    }
    widget.productSummary.productName = name;
    if(!mounted) return;
    Navigator.of(context).pop(); 
    setState(() { });
  }

  Future deleteProduct() async {
    showDialog(context: context, builder: ((context) => const Center(child: CircularProgressIndicator())));
    for (var product in widget.boughtProducts) {
      await BoughtProductsApi.deleteProduct(product);
    }
    if(!mounted) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Menu()),
        (Route<dynamic> route) => false,);
    }); 
  }
}