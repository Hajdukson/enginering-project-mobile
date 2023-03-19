class BoughtProduct {
  int? id;
  String? name;
  double? price;
  DateTime? boughtDate;
  String? imagePath;

  BoughtProduct({this.id, this.name, this.price, this.boughtDate, this.imagePath});

  factory BoughtProduct.fromJson(Map<String, dynamic> json) {
    return BoughtProduct(
      id: json['id'],
      name: json['name'], 
      price: double.parse(json['price'].toString()), 
      boughtDate: DateTime.parse(json['boughtDate']),
      imagePath: json['imagePath']);
  }
}