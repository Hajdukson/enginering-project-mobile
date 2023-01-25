// ignore_for_file: prefer_const_constructors

class BoughtProduct {
  int? id;
  String? name;
  double? price;
  DateTime? boughtDate;

  BoughtProduct({this.id, this.name, this.price, this.boughtDate});

  factory BoughtProduct.fromJson(Map<String, dynamic> json) {
    return BoughtProduct(id: json['id'] ,name: json['name'], price: double.parse(json['price'].toString()), boughtDate: DateTime.parse(json['boughtDate']));
  }
}