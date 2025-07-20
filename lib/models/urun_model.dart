class UrunModel {
  final String name;
  final String price;
  final bool stoktaVar;

  UrunModel({required this.name, required this.price, required this.stoktaVar});

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'stoktaVar': stoktaVar,
  };

  factory UrunModel.fromJson(Map<String, dynamic> json) => UrunModel(
    name: json['name'] ?? '',
    price: json['price'] ?? '',
    stoktaVar: json['stoktaVar'] ?? true,
  );
}
