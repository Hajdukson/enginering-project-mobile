import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:money_manager_mobile/flavor/flavor_config.dart';

import '../models/bought_product.dart';

class BoughtProductsApi {
  static final String _baseUrl = FlavorConfig.instance.values.baseUrl;

  static Future<List<BoughtProduct>> analizeReceipt(XFile image) async {
    var uri = Uri.parse("$_baseUrl/api/boughtproducts/analize");
    var request = http.MultipartRequest("GET", uri);
    request.files
        .add(await http.MultipartFile.fromPath('file', image.path));

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
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
  static Future<List<BoughtProduct>> postProducts() {
    throw HttpStatus.notImplemented;
  }
  static Future<BoughtProduct> postSingeProduct() {
    throw HttpStatus.notImplemented;
  }
}