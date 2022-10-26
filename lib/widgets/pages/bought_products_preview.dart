import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:money_manager_mobile/models/bought_product.dart';

class BoughtProductsPreView extends StatefulWidget {
  const BoughtProductsPreView({required this.image, Key? key})
      : super(key: key);
  final XFile image;

  @override
  State<BoughtProductsPreView> createState() => _BoughtProductsPreViewState();
}

class _BoughtProductsPreViewState extends State<BoughtProductsPreView> {
  late Future<void> futureBoughtProducts;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureBoughtProducts = fetchBoughtProducts();
  }

  Future<BoughtProduct> fetchBoughtProducts() async {
    var uri = Uri.parse("https://192.168.1.34:7075/api/boughtproducts/analize");
    var request = http.MultipartRequest("POST", uri);
    request.files
        .add(await http.MultipartFile.fromPath('file', widget.image.path));

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var responseAsJosn = jsonDecode(respStr);
      return const BoughtProduct(Name: "this", Price: 2.0);
    } catch (e) {
      print(e);
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping list"),
      ),
      body: Stack(
        children: [
          Image.file(File(widget.image.path)),
          FutureBuilder<void>(
              future: futureBoughtProducts,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AlertDialog(
                    title: const Center(child: Text("Some products were found.")),
                    actions: [
                      Center(
                        child: SizedBox(
                          width: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Center(child: Text('Ok'))),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              })),
        ],
      ),
    );
  }
}

        // final dialog = await showDialog(
        //   context: context, 
        //   builder: (context) {
        //   return AlertDialog(
        //     title: const Center(child: Text("No API connected.")),
        //     actions: [
        //       Center(
        //         child: SizedBox(
        //           width: 50,
        //           child: ElevatedButton(
        //             onPressed: () {
        //             Navigator.pop(context, true);
        //           }, 
        //           child: const Center(child: Text('Ok'))),
        //         ),
        //       ),
        //     ],
        //   );
        // });