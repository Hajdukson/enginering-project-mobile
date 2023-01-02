import 'package:money_manager_mobile/models/bought_product.dart';

class ProductSummary {
  String? productName;
  BoughtProduct? startProduct;
  BoughtProduct? endProduct;
  double? porductInflation;

  ProductSummary({this.productName, this.endProduct, this.startProduct, this.porductInflation});

  factory ProductSummary.fromJson(Map<String, dynamic> json) {
    return ProductSummary(
      productName: json["name"], 
      endProduct: BoughtProduct.fromJson(json["endProduct"]), 
      startProduct: BoughtProduct.fromJson(json["startProduct"]), 
      porductInflation: double.parse(json["inflation"].toString()));
  } 
}