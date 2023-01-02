import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:money_manager_mobile/flavor/flavor_config.dart';

import '../models/bought_product.dart';
import '../models/product_summary.dart';

class BoughtProductsApi {
  static final String _baseUrl = FlavorConfig.instance.values.baseUrl;
  static final String _modelUrl = "$_baseUrl/api/boughtproducts";

  static Future<List<BoughtProduct>> analizeReceipt(File image) async {
    var uri = Uri.parse("$_modelUrl/analize");
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

    var uri = Uri.parse("$_modelUrl/addboughtproducts");

    await http.post(
      uri, 
      headers: {
        "Accept": "application/json",
        "content-type":"application/json"
      },
      body: _decodeProducts(products)
    );
  }
  
  static Future<List<BoughtProduct>> getProducts() async {
    var uri = Uri.parse(_modelUrl);

    var respons = await http.get(uri);
    List json = jsonDecode(respons.body);
    
    return json.map((e) => BoughtProduct.fromJson(e)).toList();
  }

  static Future<List<ProductSummary>> getPrductsSummaries() async {
    var uri = Uri.parse("$_modelUrl/distinctproducts");

    var response = await http.get(uri);
    List json = jsonDecode(response.body);
    return json.map((e) => ProductSummary.fromJson(e)).toList();
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