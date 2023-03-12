import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:money_manager_mobile/api_calls/bought_products._api.dart';
import 'package:money_manager_mobile/menu/menu.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/models/selectable_item_.dart';
import 'package:money_manager_mobile/views/receipt_view.dart';

class BoughtProductsAnalizer extends StatefulWidget {
  const BoughtProductsAnalizer({required this.image, Key? key})
      : super(key: key);
  final File image;

  @override
  State<BoughtProductsAnalizer> createState() => _BoughtProductsAnalizerState();
}

class _BoughtProductsAnalizerState extends State<BoughtProductsAnalizer> {
  late Future<List<BoughtProduct>> futureBoughtProducts;
  @override
  void initState() {
    super.initState();

    // try
    // {
    //   futureBoughtProducts = BoughtProductsApi.analizeReceipt(widget.image);
    // } on Exception catch(e) {
    //   showDialog(context: context, builder: (context) => 
    //     const Dialog(child: SizedBox(
    //       height: 100,
    //       width: 100,
    //       child: Text("Error"),),));
    // }
  }

  @override
  Widget build(BuildContext context) {
    _navigateToReceiptView(widget.image);
    return Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Image.file(File(widget.image.path))),
            const Center(child: CircularProgressIndicator())
          // FutureBuilder<List<BoughtProduct>>(
          //     future: futureBoughtProducts,
          //     builder: ((context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         if(snapshot.hasData) { 
          //           SchedulerBinding.instance.addPostFrameCallback((_) {
          //             Navigator.of(context).pushAndRemoveUntil(
          //               MaterialPageRoute(
          //                 builder: (context) => ReceiptView(recipt: snapshot.data!.map((e) => SelectableItem(e)).toList())),
          //               (Route<dynamic> route) => false,);
          //           });
          //         }
                  
          //       }
          //       return const Center(child: CircularProgressIndicator());
          //     })),
        ],
      );
  }

  Future _navigateToReceiptView(File image) async {
    var futureBoughtProducts = await BoughtProductsApi.analizeReceipt(image);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: ReceiptView(recipt: futureBoughtProducts.map((e) => SelectableItem(e)).toList()))),
      (Route<dynamic> route) => false,);});
  }
}