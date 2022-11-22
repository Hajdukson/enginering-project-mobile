import 'dart:io';
import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/pages/recipt_view.dart';

import '../../api_calls/bought_products._api.dart';

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

    try
    {
      futureBoughtProducts = BoughtProductsApi.analizeReceipt(widget.image, context);
    } on Exception catch(e) {
      showDialog(context: context, builder: (context) => 
        Dialog(child: Container(
          height: 100,
          width: 100,
          child: Text("Error"),),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Image.file(File(widget.image.path))),
          FutureBuilder<List<BoughtProduct>>(
              future: futureBoughtProducts,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if(snapshot.hasData){ 
                    return ReceiptView(recipt: snapshot.data as List<BoughtProduct>,);
                  }
                }
                return const Center(child: CircularProgressIndicator());
              })),
        ],
      );
  }
}