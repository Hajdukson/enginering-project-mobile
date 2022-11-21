import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/pages/recipt_view.dart';

import '../../api_calls/bought_products._api.dart';

class BoughtProductsAnalizer extends StatefulWidget {
  const BoughtProductsAnalizer({required this.image, Key? key})
      : super(key: key);
  final XFile image;

  @override
  State<BoughtProductsAnalizer> createState() => _BoughtProductsAnalizerState();
}

class _BoughtProductsAnalizerState extends State<BoughtProductsAnalizer> {
  late Future<List<BoughtProduct>> futureBoughtProducts;
  @override
  void initState() {
    super.initState();
    futureBoughtProducts = BoughtProductsApi.analizeReceipt(widget.image);
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