import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:money_manager_mobile/flavor/flavor_config.dart';

import '../models/bought_product.dart';

class BoughtProductsApi {
  static final String _baseUrl = FlavorConfig.instance.values.baseUrl;

  static Future<List<BoughtProduct>> analizeReceipt(File image) async {
    var uri = Uri.parse("$_baseUrl/api/boughtproducts/analize");
    var request = http.MultipartRequest("GET", uri);
    request.files
        .add(await http.MultipartFile.fromPath('file', image.path));

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      if(respStr.isEmpty) {
        throw Exception("'respStr' was empty - Check filesize. Filesize should be lesser than 4mb");
      }
      var responseAsJosn = jsonDecode(respStr);
      List<BoughtProduct> boughtProducts = [];

      for (var boughtProduct in responseAsJosn) {
        boughtProducts.add(BoughtProduct.fromJson(boughtProduct));
      }

      return boughtProducts;
    } on Exception catch (e) {
      print(e);
      throw Exception("Failed to load data");
    }
  }

  static void postProducts(List<BoughtProduct> products) async {
    if(products.isEmpty) {
      throw Exception("In method 'postProducts' 'List<BoughtProducts>' was empty");
    }
    
    var uri = Uri.parse("$_baseUrl/api/boughtproducts/addboughtproducts");

    try {
      var request = await http.post(
        uri, 
        headers: {
          "Accept": "application/json",
          "content-type":"application/json"
        },
        body: _decodeProducts(products));
    }
    on Exception catch (e) {
      print(e);
    }
  }

  static Future<BoughtProduct> postSingeProduct() {
    throw HttpStatus.notImplemented;
  }

  static String _decodeProducts(List<BoughtProduct> products) {
    List<Map<String, dynamic>> productsAsJson = products.map((e) => {
      "id" : e.id,
      "name" : e.name,
      "price" : e.price,
      "boughtDate" : e.boughtDate!.toIso8601String(),
    }).toList();
    return jsonEncode(productsAsJson);
  }
}