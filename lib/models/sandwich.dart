class Sandwich {
  final String image;
  final String title;
  final String desc;
  final String price;
  final bool stock;

  Sandwich({
    required this.image,
    required this.title,
    required this.desc,
    required this.price,
    required this.stock,
  });

  factory Sandwich.fromJson(Map<String, dynamic> json) {
    return Sandwich(
      image: json['image'],
      title: json['title'],
      desc: json['desc'],
      price: json['price'],
      stock: json['stock'],
    );
  }
}
