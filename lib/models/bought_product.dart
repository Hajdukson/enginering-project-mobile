class BoughtProduct {
  final String Name;
  final double Price;

  const BoughtProduct({required this.Name, required this.Price});

  factory BoughtProduct.fromJson(Map<String, dynamic> json) {
    return BoughtProduct(Name: json['Name'], Price: json['Price']);
  }
}