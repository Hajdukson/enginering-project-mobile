class BoughtProduct {
  final int? id;
  final String? name;
  final double? price;
  final DateTime? boughtDate;

  const BoughtProduct({this.id, this.name, this.price, this.boughtDate});

  factory BoughtProduct.fromJson(Map<String, dynamic> json) {
    return BoughtProduct(id: json['id'] ,name: json['name'], price: double.parse(json['price'].toString()), boughtDate: DateTime.parse(json['boughtDate']));
  }
}