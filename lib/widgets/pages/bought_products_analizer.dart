import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:money_manager_mobile/models/bought_product.dart';
import 'package:money_manager_mobile/widgets/pages/bought_products_preview.dart';

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
    // TODO: implement initState
    super.initState();
    futureBoughtProducts = fetchBoughtProducts();
  }

  Future<List<BoughtProduct>> fetchBoughtProducts() async {
    var uri = Uri.parse("https://192.168.1.34:7075/api/boughtproducts/analize");
    var request = http.MultipartRequest("GET", uri);
    request.files
        .add(await http.MultipartFile.fromPath('file', widget.image.path));

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var responseAsJosn = jsonDecode(respStr);
      List<BoughtProduct> boughtProducts = [];

      for (var boughtProduct in responseAsJosn) {
        boughtProducts.add(BoughtProduct.fromJson(boughtProduct));
      }

      return boughtProducts;
    } catch (e) {
      print(e);
      throw Exception("Failed to load data");
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
                    return BoughtProductsPreview(boughtProducts: snapshot.data as List<BoughtProduct>);
                  }
                }
                return const Center(child: CircularProgressIndicator());
              })),
        ],
      );
  }
}