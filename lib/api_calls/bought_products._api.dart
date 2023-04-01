import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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

    var response = await request.send();

    if(response.statusCode == 200 || response.statusCode == 201) {
      var respStr = await response.stream.bytesToString();
      var responseAsJosn = jsonDecode(respStr);
      List<BoughtProduct> boughtProducts = [];

      for (var boughtProduct in responseAsJosn) {
        boughtProducts.add(BoughtProduct.fromJson(boughtProduct));
      }
      return boughtProducts;
    }
    throw Exception("Cannot analize image\nCheck image size or make sure it contained text");
  }

  static Future<BoughtProduct> deleteProduct(BoughtProduct boughtProduct) async {
    int productId = boughtProduct.id!;

    var uri = Uri.parse("$_modelUrl/$productId");

    var response = await http.delete(uri);

    if(response.statusCode == 200 || response.statusCode == 201) {
      return BoughtProduct.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to delete product");
    }
  }

  static Future<String> deleteImage(String imagePath) async {
    var uri = Uri.parse("$_modelUrl/deleteimage").replace(
      queryParameters: <String, String> {
        "imagePath" : imagePath
      }
    );

    var response = await http.delete(uri);

    if(response.statusCode == 201 || response.statusCode == 200) {
      return response.body;
    }
    return throw Exception("Cannot delete image");
  }

  static Future<List<BoughtProduct>> deleteProductsByName(List<String> names) async {
    var uri = Uri.parse("$_modelUrl/deletebynames");

    var response = await http.delete(
      uri,
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      },
      body: jsonEncode(names)
    );
    if(response.statusCode == 200 || response.statusCode == 201) {
      var productsJson = jsonDecode(response.body);

      List<BoughtProduct> result = [];
      for (var json in productsJson) {
        result.add(BoughtProduct.fromJson(json));
      }

      return result;
    } else {
      throw Exception("Fialed to delete products");
    }
  }

  static Future<String> postProducts(List<BoughtProduct> products) async {
    if(products.isEmpty) {
      throw Exception("In method 'postProducts' 'List<BoughtProducts>' was empty");
    }

    var uri = Uri.parse("$_modelUrl/addboughtproducts");

    var response = await http.post(
      uri, 
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      },
      body: _decodeProducts(products)
    );

    if(response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception("Failed to post list of products");
    }
  }

  static Future<BoughtProduct> postSingeProduct(BoughtProduct boughtProduct) async {
    var uri = Uri.parse(_modelUrl);

    boughtProduct.id ??= 0;

    final response = await http.post(
      uri,
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      },
      body: _decodeProduct(boughtProduct)
    );

    if(response.statusCode == 201|| response.statusCode == 200) {
      return BoughtProduct.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to post product");
    }
  }

  static Future editProduct(BoughtProduct boughtProduct) async {
    var productId = boughtProduct.id!;
    var uri = Uri.parse("$_modelUrl/$productId");

    final response = await http.put(
      uri,
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      },
      body: _decodeProduct(boughtProduct)
    );

    if(response.statusCode == 201 || response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to edit product");
    }
  }
  
  static Future<List<BoughtProduct>> getProducts({String? name}) async {
    var uri = Uri.parse(_modelUrl).replace(queryParameters: <String, dynamic> {"name" : name});

    var response = await http.get(uri);
    List json = jsonDecode(response.body);
    if(response.statusCode == 201 || response.statusCode == 200) {
      return json.map((e) => BoughtProduct.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  static Future<List<ProductSummary>> getPrductsSummaries({String? name, DateTimeRange? dates}) async {
    var uri = Uri.parse("$_modelUrl/distinctproducts").replace(queryParameters: <String, dynamic> {
      "name" : name,
      "startDate" : dates?.start.toIso8601String(),
      "endDate" : dates?.end.toIso8601String() },);

    var response = await http.get(uri);
    List json = jsonDecode(response.body);
    if(response.statusCode == 201 || response.statusCode == 200) {
      return json.map((e) => ProductSummary.fromJson(e)).toList();
    } else {
      throw Exception("Failed to get products summaries");
    }
  }
  
  static Future<List<BoughtProduct>> getProductsFromConreteReceipt(String imagePath) async {
    var uri = Uri.parse("$_modelUrl/receiptproducts").replace(
      queryParameters: <String, String> {
        "imagePath" : imagePath
      }
    );

    var response = await http.get(uri);
    List json = jsonDecode(response.body);

    if(response.statusCode == 200 || response.statusCode == 201) {
      return json.map((e) => BoughtProduct.fromJson(e)).toList();
    } else {
      throw Exception("Failed to get products from receipt");
    }
  }

  static String _decodeProduct(BoughtProduct boughtProduct) {
    Map<String, dynamic> bp = {
      "id" : boughtProduct.id,
      "name" : boughtProduct.name,
      "price" : boughtProduct.price,
      "boughtDate" : boughtProduct.boughtDate!.toIso8601String()
    };

    return jsonEncode(bp);
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